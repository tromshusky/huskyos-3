{ ... }:{
    imports = [
        ./bind-mounts.nix
        ./filesystems.nix
        ./flathub.nix
        ./huskyos-options.nix
        ./nixos-rebuild.nix
    ];
    
    boot.loader.grub.enable = false;
    boot.loader.systemd-boot.enable = false;

    environment.etc."huskyos".source = config.huskyos.flakeFolder;

    boot.plymouth.enable = true;
    documentation.enable = false;
    environment.systemPackages = with pkgs; [ nautilus efibootmgr sbctl ];
    services.desktopManager.gnome.enable = true;
    services.displayManager.gdm.enable = true;
    services.gnome.core-apps.enable = false;
    

    time.timeZone = "Europe/Amsterdam";

    users.users.root.password = "asd";

    users.users.user.isNormalUser = true;
    users.users.user.password = "";
    services.displayManager.autoLogin.user = "user";

    zramSwap.enable = true;

}