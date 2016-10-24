{ pkgs, ... }:

with pkgs; {
  environments = rec {
    common = import ./common { inherit pkgs; };
    development = import ./development { inherit pkgs; };
    gaming = import ./gaming { inherit pkgs; };
    media = import ./media { inherit pkgs; };
    office = import ./office { inherit pkgs; };
    workstation = import ./workstation { inherit pkgs; };

    # Home desktop environment
    desktopEnv = buildEnv {
      name = "desktop-environment";
      paths = [
        common
        development.base
        development.haskell
        development.node
        development.tools
        gaming
        media.extra
        office.extra
        workstation.extra
      ];
    };
  };
}
