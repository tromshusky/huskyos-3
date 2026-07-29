{
  config,
  lib,
  pkgs,
  ...
}:
{
  documentation.enable = false;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.gnome.core-apps.enable = false;
}
