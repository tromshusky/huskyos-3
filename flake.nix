{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs =
    { self, nixpkgs, ... }:
    {
      withSelf =
        selfArg:
        let
          hw_nix = "${selfArg.outPath}/hardware-configuration.nix";
          hardwareConfiguration = { pkgs, ... }@args: ((import hw_nix args) // { fileSystems = { }; });
        in
        {
          nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
            modules = [
              hardwareConfiguration
              ./configuration.nix
              {
                nix.settings.experimental-features = [ "nix-command flakes" ];
                huskyos.flakeFolder = "${selfArg.outPath}";
              }
            ];
          };
        };
    };
}
