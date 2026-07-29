{ config, lib, ... }:
let
  EFI = lib.fileContents "${config.huskyos.flakeFolder}/EFI";
  BTR = lib.fileContents "${config.huskyos.flakeFolder}/BTR";
in
{

  fileSystems."/" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [
      "size=16G"
      "mode=0755"
    ];
  };

  fileSystems."/boot" = {
    device = EFI;
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  fileSystems."/nix" = {
    device = BTR;
    fsType = "btrfs";
    options = [ "subvol=@huskyos/@nix-A" ];
  };

  fileSystems."/userdata" = {
    device = BTR;
    fsType = "btrfs";
    options = [ "subvol=@huskyos/@userdata-B" ];
  };

  fileSystems."/systemdata" = {
    device = BTR;
    fsType = "btrfs";
    options = [ "subvol=@huskyos/@systemdata-A" ];
  };

  fileSystems."/etc/NetworkManager" = {
    device = "/systemdata/etc/NetworkManager";
    fsType = "none";
    options = [ "bind" ];
  };

  fileSystems."/home/user/.var" = {
    device = "/systemdata/home/user/.var";
    fsType = "none";
    options = [ "bind" ];
  };

  fileSystems."/home/user/.cache" = {
    device = "/systemdata/home/user/.cache";
    fsType = "none";
    options = [ "bind" ];
  };

  fileSystems."/home/user/.local" = {
    device = "/systemdata/home/user/.local";
    fsType = "none";
    options = [ "bind" ];
  };

  fileSystems."/home/user/.config" = {
    device = "/systemdata/home/user/.config";
    fsType = "none";
    options = [ "bind" ];
  };

  swapDevices = [ ];
}
