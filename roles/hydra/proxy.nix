# Hydra proxy. This is so I can run hydra on my desktop but make it accessible
# via a VPS to get around carrier grade NAT.
{ config, pkgs, ... }:

{
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    virtualHosts = {
      "hydra.server.geek.nz" = {
        forceSSL = true;
        enableACME = true;
        locations."/".proxyPass = "http://10.99.0.2:3000";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  # Allow port forwarding clients to specify the address to which the ports are bound
  services.openssh.gatewayPorts = "clientspecified";
}
