{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.huskyos.flakeFolder = lib.mkOption { type = lib.types.path; };
  imports = [
    ./user-bind-mounts.nix
    ./critical.nix
    ./gnome.nix
    ./flathub.nix
    ./filesystems.nix
  ];
  config.time.timeZone = "Europe/Amsterdam";

  config.environment.systemPackages = with pkgs; [
    sbctl
    efibootmgr
    rio
    librewolf
    nixfmt
  ];

}
