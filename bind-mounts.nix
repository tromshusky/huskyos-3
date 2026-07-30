{ pkgs, ... }:{
  systemd.services.huskyos-bind-mounts.wantedBy = [ "basic.target" ]; 
  systemd.services.huskyos-bind-mounts.script = ''
    PATH=$PATH:${pkgs.util-linux}/bin

    for dir in  var/lib  etc/NetworkManager  root ; do
      mkdir -p       /systemdata/$dir /$dir;
      mount --bind   /systemdata/$dir /$dir;
    done;
    chmod 0700       /systemdata/root /root;

    for dir in  home/user/.cache  home/user/.config  home/user/.local  home/user/.var ; do
      mkdir -p       /systemdata/$dir /$dir;
      chown 1000:100 /systemdata/$dir /$dir;
      chmod 0700     /systemdata/$dir /$dir;
      mount --bind   /systemdata/$dir /$dir;
    done;

    for dir in  Desktop  Documents  Downloads  Music  Pictures  Projects  Public  Templates  Videos ; do
      mkdir -p       /userdata/home/user/$dir /home/user/$dir;
      chown 1000:100 /userdata/home/user/$dir /home/user/$dir;
      chmod 0700     /userdata/home/user/$dir /home/user/$dir;
      mount --bind   /userdata/home/user/$dir /home/user/$dir;
    done;
    chown 1000:100   /userdata/home/user      /home/user;
    chmod 0700       /userdata/home/user      /home/user;
  '';
}
