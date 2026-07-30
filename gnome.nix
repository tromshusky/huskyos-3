{
  config,
  lib,
  pkgs,
  ...
}:
{
  documentation.nixos.enable = false;
  environment.systemPackages = [ pkgs.nautilus ];
  environment.gnome.excludePackages = [ pkgs.gnome-tour ];
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.gnome.core-apps.enable = false;
}
