{ config, pkgs, ... }:

{
  virtualisation.docker.enable = true;
  services.virtualboxHost.enable = true;

  # In order to pass USB devices from the host to the guests,
  # the user needs to be in the vboxusers group
  users.extraGroups.vboxusers.members = [ "leroy" ];
}
