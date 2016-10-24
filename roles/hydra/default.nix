{ config, pkgs, ... }:
#
# Initialization commands
#
# on hydra master:
# - hydra-create-user leroy --full-name 'Leroy Hopson' --email-address 'hydra@leroy.geek.nz' --password 'xxx' --role admin
# - install -d -m 551 /etc/hydra
# - nix-store --generate-binary-cache-key hydra.server.geek.nz /etc/hydra/key.private /etc/hydra/key.public
# - chown -R hydra:hydra /etc/hydra
# - chmod 440 /etc/hydra/key.private
# - chmod 444 /etc/hydra/key.public
# - sudo scp -i /home/leroy/.ssh/id_rsa /root/.ssh/id_buildfarm root@au-03.nix.nz:/root/.ssh/
{
  nix.distributedBuilds = true;

  nix.buildMachines = [
    { hostName = "localhost";
      maxJobs = 4;
      system = "x86_64-linux";
      supportedFeatures = [ "kvm" "nixos-test" "big-parallel" ];
    }
    { hostName = "nz-01.nix.nz";
      maxJobs = 8;
      sshUser = "builduser";
      sshKey = "/etc/hydra/id_buildfarm";
      supportedFeatures = [ "kvm" "nixos-test" "big-parallel" ];
      system = "x86_64-linux";
    }
    { hostName = "mac-01.nix.nz";
      maxJobs = 16;
      sshUser = "leroy";
      sshKey = "/etc/hydra/id_buildfarm";
      system = "x86_64-darwin";
    }
  ];

  nix.extraOptions = "auto-optimise-store = true";
  nix.nrBuildUsers = 30;
  nix.gc.automatic = true;

  nixpkgs.config.allowUnfree = true;

  services.hydra =
    { enable = true;
      dbi = "dbi:Pg:dbname=hydra;user=hydra;";
      hydraURL = "https://hydra.server.geek.nz";
      listenHost = "10.99.0.2";
      port= 3000;
      extraConfig = "binary_cache_secret_file = /etc/hydra/key.private";
      minimumDiskFree = 2; # in GB
      notificationSender = "hydra@hydra.server.geek.nz";
    };

  networking.firewall.allowedTCPPorts = [ 3000 ];

  # Some of the build hosts are actually forwarding their ssh ports. Therefore,
  # we need to set up aliases in the hosts file and configure ssh to connect
  # to the correct port.
  networking.extraHosts = ''
    10.99.0.1 nz-01.nix.nz
    10.99.0.1 mac-01.nix.nz
  '';

  programs.ssh.extraConfig = ''
    strictHostKeyChecking no

    Host nz-01.nix.nz
        Port 2222

    Host mac-01.nix.nz
        Port 2223
  '';
}
