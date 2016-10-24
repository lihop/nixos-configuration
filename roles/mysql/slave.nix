{ config, pkgs, mysqlReplPass ? "", mysqlRootPass ? "", ... }:

{
  services.mysql = {
    enable = true;
    package = pkgs.mysql55;
    rootPassword = builtins.toFile "mysqlRootPass" mysqlRootPass;
    extraOptions = ''
      bind_address = "10.99.0.3"
    '';
    replication = {
      role = "slave";
      serverId = 2;
      masterHost = "10.99.0.2";
      masterUser = "repl";
      masterPassword = builtins.toFile "mysqlReplPass" "gaeKae8phe6k";
    };
  };

  networking.firewall.allowedTCPPorts = [ 3306 ];
}
