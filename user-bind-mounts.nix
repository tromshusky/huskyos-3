{ pkgs, ... }:{
  systemd.services.huskyos-user-bind-mounts.wantedBy = [ "multi-user.target" ]; 
  systemd.services.huskyos-user-bind-mounts.script = ''
    PATH=$PATH:${pkgs.util-linux}/bin
    for dir in Desktop  Documents  Downloads  Music  Pictures  Projects  Public  Templates  Videos; do
      mkdir -p       /userdata/home/user/$dir /home/user/$dir;
      chown 1000:100 /userdata/home/user/$dir /home/user/$dir;
      chmod 0700     /userdata/home/user/$dir /home/user/$dir;
      mount --bind   /userdata/home/user/$dir /home/user/$dir;
    done;
    chown 1000:100 /userdata/home/user /home/user;
    chmod 0700 /userdata/home/user /home/user;
  '';
}
