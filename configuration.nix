{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.huskyos.flakeFolder = lib.mkOption { type = lib.types.path; };
  imports = [
    ./bind-mounts.nix
    ./critical.nix
    ./gnome.nix
    ./flathub.nix
    ./filesystems.nix
  ];
  config.time.timeZone = "Europe/Amsterdam";

  config.boot.plymouth.enable = true;
  config.boot.kernelParams = [ "quiet" "loglevel=2" ];

  config.environment.systemPackages = with pkgs; [
    sbctl
    efibootmgr
    nixfmt
  ];

}
