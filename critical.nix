#!/usr/bin/env -S /bin/sh -c 'cat $0 | tail -n+2 | grep -A100 "#!" | unshare -m'
{
  config,
  lib,
  pkgs,
  ...
}:
let
  
  updatescript = with pkgs; with config.huskyos; ''
    #!/usr/bin/env -S /bin/sh -c 'export PATH=/run/current-system/sw/bin; cat $0 | unshare -m'
    PATH=/run/current-system/sw/bin:${nix}/bin:${sbctl}/bin; 
    set -euo pipefail
    flakeFolder=.
    echo starting system update script...
    mkdir --parents /var/lib/sbctl &&
    mount --bind /boot/sbctl /var/lib/sbctl &&
    [ -d /boot/efi/boot ] &&
    echo ...building uki &&
    uki=$(nix build ${flakeFolder}#nixosConfigurations.huskyos.config.system.build.{uki,toplevel} --print-out-paths --out-link /nix/var/nix/gcroots/next-system | head -n1)/nixos.efi &&
    echo ...installing uki &&
    cd /boot/efi/boot &&
    if [ -e BOOTX64-unsigned.EFI ]; then rm BOOTX64-unsigned.EFI; fi &&
    cp $uki BOOTX64-unsigned.EFI &&
    sbctl sign BOOTX64-unsigned.EFI &&
    mv --verbose --force --no-target-directory BOOTX64-unsigned.EFI BOOTX64_NEXT.EFI &&
    echo ...done &&
    sleep 5 &&
    echo collecting some garbage... &&
    nix-collect-garbage --delete-older-than 3d || { EX="$?"; set +u; exit $EX; };
    set +u; # suppressing: /etc/bash_logout: line 4: __ETC_BASHLOGOUT_SOURCED: unbound variable
    exit 0;
  '';

  pwPath = "${config.huskyos.flakeFolder}/RPW";
  rpw = if (builtins.pathExists pwPath) && (builtins.readFileType pwPath == "regular") then (lib.fileContents pwPath) else null;
in
{
  boot.initrd.systemd.emergencyAccess = true;
  boot.loader.grub.enable = false;
  boot.loader.systemd-boot.enable = false;

  environment.systemPackages = [ (pkgs.writeScriptBin "huskyos-update" updatescript) ];
  system.tools.nixos-rebuild.enable = false;
  system.autoUpgrade.enable = true;
  system.build.nixos-rebuild = lib.mkForce (pkgs.writeScriptBin "nixos-rebuild" updatescript);

  systemd.services.huskyos-flag-boot-success.after = [ "multi-user.target" ];
  systemd.services.huskyos-flag-boot-success.wantedBy = [ "multi-user.target" ];
  systemd.services.huskyos-flag-boot-success.script = ''
    set -euo pipefail
    PATH=$PATH:${pkgs.efibootmgr}/bin
    NEXT_NUM=$(efibootmgr | grep -oP "^Boot\K.{4}(?=..HuskyOS Next)")
    efibootmgr -n $NEXT_NUM
  '';

  environment.etc.huskyos.source = "${config.huskyos.flakeFolder}";

  users.users.root.hashedPassword = rpw;

  services.displayManager.autoLogin.user = "user";
  users.users.user.isNormalUser = true;
  users.users.user.password = "";
  users.users.user.uid = 1000;
  system.stateVersion = "26.11";
}
