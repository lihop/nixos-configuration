{ config, pkgs, ... }:

{
  virtualisation.docker.enable = true;
  # virtualisation.virtualbox.host.enable = true;
  # virtualisation.libvirtd.enable = true;

  # In order to pass USB devices from the host to the guests,
  # the user needs to be in the vboxusers group
  users.extraGroups.vboxusers.members = [ "leroy" ];

  environment.systemPackages = with (import ../../envs { inherit pkgs; }); [
    environments.media.extra
    environments.office.extra
    environments.workstation.extra
  ];
}
