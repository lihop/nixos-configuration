{ config, pkgs, ... }:

{
  nixpkgs.config = {
    allowUnfree = true;

    firefox = {
      enableAdobeFlash = true;
    };
  };

  environment.systemPackages = with (import ../../envs { inherit pkgs; }); [
    environments.development.base
    environments.media.minimal
    environments.office.minimal
    environments.workstation.minimal
  ];

  services.xserver = {
    enable = true;

    layout = "us";
    xkbVariant = "dvp";

    displayManager = {
      lightdm.enable = true;
      #auto.user = "leroy";
      #auto.enable = true;
      sessionCommands =
        ''
          gpg-connect-agent /bye
          GPG_TTY=$(tty)
          export GPG_TTY

          urxvtd -q -f -o
        '';
    };

    windowManager = {
      default = "xmonad";
      xmonad.enable = true;
      xmonad.enableContribAndExtras = true;
    };

#    desktopManager.xterm.enable = false;
  };

  hardware.pulseaudio.enable = true;
  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts
      dejavu_fonts
      meslo-lg
      powerline-fonts
      ubuntu_font_family
    ];
  };
}
