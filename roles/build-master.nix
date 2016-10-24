{ config, pkgs, ... }:
#
# Initialization commands
#
# on the build master
# - sudo ssh-keygen -b 4096 -N "" -f /root/.ssh/id_buildfarm
# - (umask 277 && openssl genrsa -out /etc/nix/signing-key.sec 2048)
# - openssl rsa -in /etc/nix/signing-key.sec -pubout > /etc/nix/signing-key.pub
# - sudo nixops scp -s /home/leroy/.nixops/deployments.nixops --to <host> /etc/nix/signing-key.sec /etc/nix/signing-key.sec
# - sudo nixops scp -s /home/leroy/.nixops/deployments.nixops --to <host> /etc/nix/signing-key.pub /etc/nix/signing-key.pub
#
let
  hosts =
    [ "au-01"
      "au-02"
      "au-03"
    ];

  defineMachine = host:
    {
      hostName = host + ".nix.nz";
      sshUser = "builduser";
      sshKey = "/etc/nix/hydra/id_buildfarm";
      system = "x86_64-linux";
    };

in
  {
    nix.distributedBuilds = true;
    nix.buildMachines = 
      [
        { hostName = "192.168.3.7";
          sshUser = "leroy";
          sshKey = "/etc/nix/hydra/id_buildfarm";
          system = "powerpc-darwin";
        }
      ] ++ (map defineMachine hosts);
  }
