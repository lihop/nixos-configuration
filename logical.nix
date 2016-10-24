{ mysqlRootPass, mysqlReplPass, mailUserPass, ... }:

{
  network.description = "Production NixOPS network";

  nz1 =
    { config, pkgs, ... }:
    { system.stateVersion = "16.03";
      networking.hostName = "nz-01.nix.nz";

      imports = [
        ./roles/common
        ./roles/gaming
        ./roles/hydra/slave.nix
        ./roles/monitored
        ./roles/server
        ./roles/workstation
        ./roles/workstation-extra
      ];

      services.udev.extraRules = ''
        SUBSYSTEM=="usb", ATTR{idVendor}=="16c0", ATTR{idProduct}=="05dc", GROUP="adm", MODE="0666"
        SUBSYSTEM=="usb", ATTR{idVendor}=="0925", ATTR{idProduct}=="3881", GROUP="adm", MODE="0666"
      '';

      hardware.bluetooth.enable = true;
    };

  au1 =
    { config, pkgs, ... }:
    { networking.hostName = "au-01.nix.nz";
      networking.interfaces.eth1.ip4 = [
        { address = "10.99.0.1"; prefixLength = 24; }
      ];

      imports = [
        ./roles/common
        ./roles/monitored
        ./roles/hydra/proxy.nix
      ];
    };

  au2 =
    { config, pkgs, ... }:
    { networking.hostName = "au-02.nix.nz";
      networking.interfaces.eth1.ip4 = [
        { address = "10.99.0.2"; prefixLength = 24; }
      ];

      imports = [
        ./roles/common
        ./roles/monitored
        (import ./roles/mysql/master.nix { inherit config; inherit pkgs; inherit mysqlRootPass; inherit mysqlReplPass; })
        (import ./roles/mail { inherit config; inherit pkgs; inherit mailUserPass; })
        ./roles/hydra
      ];

      environment.systemPackages = with (import ./envs { inherit pkgs; }); [
        environments.common
      ];
    };
}
