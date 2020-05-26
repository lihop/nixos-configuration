{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    audacity
    cypress
    discord
    dos2unix
    pythonPackages.grip
    glxinfo
    godot
    inkscape
    kazam
    krita
    nodejs-13_x
    socat
    sox
    vagrant
    xorg.xkill
  ];

  hardware.opengl.enable = true;

  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = [ "leroy" ];

  virtualisation.virtualbox.host.enable = true;
  #virtualisation.virtualbox.host.enableExtensionPack = true;
  users.extraGroups.vboxusers.members = [ "leroy" ];

  #services.nginx.enable = true;
}
