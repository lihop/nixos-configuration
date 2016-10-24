{ config, pkgs, ... }:

{
  # Send all systemd logs to papertrail
  systemd.services.papertrail = {
    enable = true;
    description = "Papertrail";
    after = [ "systemd-journald.service" ];
    bindsTo = [ "systemd-journald.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "/bin/sh -c \"journalctl -f | ${pkgs.ncat}/bin/ncat --ssl logs4.papertrailapp.com 21192\"";
      TimeoutStartSec = "0";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };

  services.riemann.enable = false;
  services.riemann-tools.enableHealth = false;
  services.riemann.config = ''
    (def librato (librato-metrics "librato@leroy.geek.nz" "bf1bc4d5b4c316fe98f94bd4badff93e573fbef68330b145d4046ca93f09fc91"))
    (logging/init {:console true})
    (tcp-server {})
    (instrumentation {:enabled? false})

    (streams
      (where (service "disk /i)
        ; Print only disk metrics
        (librato :counter)))
  '';
}
