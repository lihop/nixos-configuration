{ config, pkgs, mysqlReplPass ? "", mysqlRootPass ? "", ... }:

{
  services.mysql = {
    enable = true;
    package = pkgs.mysql55;
    rootPassword = builtins.toFile "mysqlRootPass" mysqlRootPass;
    extraOptions = ''
      bind_address = "10.99.0.2"
    '';
    replication = {
      role = "master";
      serverId = 1;
      masterUser = "repl";
      masterPassword = builtins.toFile "mysqlReplPass" "gaeKae8phe6k";
      slaveHost = "10.99.0.%";
    };
  };

  networking.firewall.allowedTCPPorts = [ 3306 ];
}
