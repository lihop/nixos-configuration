{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    acpi
    cacert
    dmenu
    linux-notification-center
    mupdf
    pinentry
    firefox
    gnupg
    libnotify
    (mutt.override { gpgmeSupport = true; })
    (pass.override { x11Support = true; })
    rxvt_unicode
    spotify
    stow
    vlc
    xorg.xev
    xorg.xmodmap
  ];

  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    displayManager.lightdm.autoLogin.enable = true;
    displayManager.lightdm.autoLogin.user = "leroy";
    displayManager.sessionCommands =
      ''
        urxvtd -q -f -o
      '';
    desktopManager.xterm.enable = false;
    layout = "us";
    synaptics = {
	twoFingerScroll = true;
	vertEdgeScroll = false;
    };
    xkbVariant = "dvp";
    windowManager.xmonad.enable = true;
    windowManager.default = "xmonad";
    windowManager.xmonad.enableContribAndExtras = true;
  };

  hardware.pulseaudio.enable = true;
  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      dejavu_fonts
      meslo-lg
      ubuntu_font_family
    ];
  };

  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "curses";
  };

  programs.yabar = {
    enable = true;
  };
}
