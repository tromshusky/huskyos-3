{ pkgs, lib, ... }:
let
  rb-script = import ./rebuild-boot.sh.nix { inherit pkgs; };
  rb-bin = pkgs.writeScriptBin "nixos-rebuild" rb-script;
in {
  system.autoUpgrade.enable = true;
  system.build.nixos-rebuild = lib.mkForce rb-bin;
  system.tools.nixos-rebuild.enable = false;
  environment.systemPackages = [ rb-bin ];
}