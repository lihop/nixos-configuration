{ config, pkgs, ... }:

{
  # Use remote forwarding to bypass CGNAT and expose the ssh port of this machine
  # to the public internet
  systemd.services.ssh-remote-forward = {
    enable = true;
    description = "SSH Remote Forward";
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.autossh}/bin/autossh -M 20000 -i /etc/hydra/id_buildfarm -N -R 10.99.0.1:2222:localhost:22 builduser@hydra.server.geek.nz";
      RestartSec = 60;
      Restart = "always";
    };
  };
}
