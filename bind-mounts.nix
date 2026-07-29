{ ... }:
let
    myservice.enable = true;
    myservice.wantedBy = [ "multi-user.target" ];
    myservice.script = ''
        PATH=$PATH:/run/wrappers/bin
        ## btrfs mounts happen somewhere else
        # mount -o subvol=@huskyos/@userdata /dev/sda2 /userdata
        # mount -o subvol=@huskyos/@systemdata /dev/sda2 /systemdata

        for dir in \
            etc/NetworkManager \
            home \
            root \
            var/lib \
        ; do
            mkdir -p /systemdata/$dir /$dir &&
            mount --bind /systemdata/$dir /$dir;
        done;

        for dir in \
            .cache \
            .config \
            .local \
            .var \
        ; do
            mkdir -p /systemdata/home/$dir /home/$dir &&
            chown 1000:100 /systemdata/home/$dir /home/$dir &&
            chmod 0700 /systemdata/home/$dir /home/$dir &&
            mount --bind /systemdata/home/$dir /home/$dir;
        done;

        for dir in \
            Desktop \
            Downloads \
            Templates \
            Public \
            Documents \
            Music \
            Pictures \
            Videos \
            Projects \
        ; do
            mkdir -p /userdata/home/$dir /home/$dir &&
            chown 1000:100 /userdata/home/$dir /home/$dir &&
            chmod 0700 /userdata/home/$dir /home/$dir &&
            mount --bind /userdata/home/$dir /home/$dir;
        done;
    '';

in
{
    systemd.services."huskyos-mounts" = myservice;
}