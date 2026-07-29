#!/usr/bin/env -S sh -c 'cat $0 | tail -n+2 | grep -A100 "#!" | unshare -m'
{
  config,
  lib,
  pkgs,
  ...
}:
let
  
  updatescript = with pkgs; with config.huskyos; ''
    #!/usr/bin/env -S sh -c 'export PATH=$PATH:${coreutils}/bin:${nix}/bin:${sbctl}/bin; cat $0 | unshare -m'
    set -euo pipefail
    flakeFolder=.
    echo starting system update script...
    mkdir --parents /var/lib/sbctl &&
    mount --bind /boot/sbctl /var/lib/sbctl &&
    [ -d /boot/efi/boot ] &&
    echo ...building uki &&
    uki=$(nix build ${flakeFolder}#nixosConfigurations.nixos.config.system.build.{uki,toplevel} --print-out-paths --out-link /nix/var/nix/gcroots/next-system | head -n1)/nixos.efi &&
    echo ...installing uki &&
    cd /boot/efi/boot &&
    if [ -e BOOTX64-unsigned.EFI ]; then rm BOOTX64-unsigned.EFI; fi &&
    cp $uki BOOTX64-unsigned.EFI &&
    sbctl sign BOOTX64-unsigned.EFI &&
    mv --verbose --force --no-target-directory BOOTX64-unsigned.EFI BOOTX64_NEXT.EFI &&
    echo ...done &&
    sleep 2 &&
    echo collecting some garbage... &&
    nix-collect-garbage &&
    exit 0 || exit 1;
  '';

in
{
  boot.initrd.systemd.emergencyAccess = true;
  boot.loader.grub.enable = false;
  boot.loader.systemd-boot.enable = false;
#  boot.loader.external.enable = true;
#  boot.loader.external.installHook = pkgs.writeShellScript "install-hook" updatescript;
  environment.systemPackages = [ (pkgs.writeScriptBin "huskyos-update" updatescript) ];
  
  system.tools.nixos-rebuild.enable = false;
  system.autoUpgrade.enable = true;
  system.build.nixos-rebuild = lib.mkForce (pkgs.writeScriptBin "nixos-rebuild" updatescript);


  services.displayManager.autoLogin.user = "user";
  users.users.user.isNormalUser = true;
  users.users.user.password = "";
  environment.etc.huskyos.source = "${config.huskyos.flakeFolder}";
  users.users.root.password = "asd";
  system.stateVersion = "26.11";
}
