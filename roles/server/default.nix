{ config, pkgs, ... }:

{
  services.httpd = {
    enable = true;
    enablePHP = true;
    adminAddr = "admin@server.geek.nz";

    virtualHosts = [
      {
        documentRoot = "/var/www/partkeeper";
        port = 8081;
      }
    ];
  };
}
