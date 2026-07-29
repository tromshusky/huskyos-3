{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.gnome-software ];
  services.flatpak.enable = true;

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id.startsWith("org.freedesktop.Flatpak.")) return polkit.Result.YES;   
    });
  '';

  systemd.services.flathub-repo.wants = [ "network-online.target" ];
  systemd.services.flathub-repo.after = [ "network-online.target" ];
  systemd.services.flathub-repo.wantedBy = [ "network-online.target" ];
  systemd.services.flathub-repo.enable = true;
  systemd.services.flathub-repo.script = ''
    PATH=$PATH:${pkgs.flatpak}/bin
    doneFile=/var/lib/flatpak/INITIALIZED
    [ -e $doneFile ] && exit
    sleep 30 &&
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo;
    touch $doneFile;
  '';
}
