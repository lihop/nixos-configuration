{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    discord
    dos2unix
    pythonPackages.grip
    glxinfo
    godot
    nodejs-13_x
    socat
    xorg.xkill
  ];

  hardware.opengl.enable = true;

  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = [ "leroy" ];
}
