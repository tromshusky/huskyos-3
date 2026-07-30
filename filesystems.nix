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
    options = [ "subvol=@huskyos/@nix" ];
  };

  fileSystems."/userdata" = {
    device = BTR;
    fsType = "btrfs";
    options = [ "subvol=@huskyos/@userdata" ];
  };

  fileSystems."/systemdata" = {
    neededForBoot = true;
    device = BTR;
    fsType = "btrfs";
    options = [ "subvol=@huskyos/@systemdata" ];
  };

  swapDevices = [ ];
}
