{ config, pkgs, ... }:

{
  fileSystems."/nix" =
    { device = "/dev/vdb";
      fsType = "btrfs";
    };
}
