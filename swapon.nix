{ config, pkgs, ... }:

{
  systemd.services.huskyos-swapon = {
    description = "Activate swap file";
    after = [ "local-fs.target" ];
    wants = [ "local-fs.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.util-linux}/bin/swapon /systemdata/swapfile";
      RemainAfterExit = true;
      FailureAction = "none";
    };
  };
}