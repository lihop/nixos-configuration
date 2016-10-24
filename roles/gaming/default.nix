{ config, pkgs, ... }:

{
  environment.systemPackages = with (import ../../envs { inherit pkgs; }); [
    environments.gaming
  ];

  # enable direct rendering for 32 bit applications
  # (required to run steam games on a 64 bit system)
  hardware.opengl.driSupport32Bit = true;
}
