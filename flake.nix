{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs =
    { nixpkgs, ... }:
    {
      withSelf =
        selfArg:
        let
          keyboard-layout = selfArg.outPath/KBD";
          hashed-root-password = selfArg.outPath/RPW;
          btrfs-device = selfArg.outPath/BTR;
          efi-device = selfArg.outPath/EFI;
          hardware-configuration = selfArg.outPath/hardware-configuration.nix;
          extra-config = fileThatExistsMapElse selfArg.outPath/config.nix (_: _) { };

          fileThatExistsMapElse =
            fPath: mapFile: els:
            if (builtins.pathExists fPath) && (builtins.readFileType fPath == "regular") then
              (mapFile fPath)
            else
              els;
          firstLineOfFileElse = fPath: els: (fileThatExistsMapElse fPath firstLine els);
          firstLine = text: (builtins.head (builtins.split "\n" (builtins.readFile text)));

          hardwareConfiguration = { pkgs, lib, config, modulesPath, ... }: (
              (import ./hardware-configuration.nix { inherit pkgs lib config modulesPath; }) // {
                fileSystems = { };
              }
            );

          buildArg = {
            modules = [
              hardwareConfiguration
              ./configuration.nix
              ./huskyos-options.nix
              {
                huskyos.btrfsDevice = builtins.readFile btrfs-device;
                huskyos.efiDevice = builtins.readFile efi-device;
                huskyos.flakeFolder = selfArg.outPath;
                huskyos.hardwareUri = hardware-configuration-no-filesystems;
                huskyos.keyboardLayout = firstLineOfFileElse keyboard-layout "us";
                huskyos.hashedRootPassword = firstLineOfFileElse hashed-root-password null;
              }
              extra-config
            ];
          };
        in
        {
          nixosConfigurations."huskyos" = nixpkgs.lib.nixosSystem buildArg;
        };
    };
}
