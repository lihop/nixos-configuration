# This module defines a small NixOS installation CD for use with a MacBookPro14,3.
{config, pkgs, ...}:
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>

    # Provide an initial copy of the NixOS channel so that the user
    # doesn't need to run "nix-channel --update" first.
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];

  boot.kernelPackages = pkgs.linuxPackages_4_17;

  boot.extraModulePackages = with config.boot.kernelPackages; [
    (import ./kernel-modules/applespi.nix)
  ];

  boot.initrd.kernelModules = [
    "applespi"
    "appletb"
    "spi_pxa2xx_platform"
    "intel_lpss_pci"
  ];

  boot.kernelParams = [
    "video=2880x1800@60"
  ];

  services.udev.extraHwdb =
  ''
  evdev:name:Apple SPI Touchpad:dmi:*:svnAppleInc.:pnMacBookPro14,3:*
    EVDEV_ABS_00=::96
    EVDEV_ABS_01=::95
    EVDEV_ABS_35=::96
    EVDEV_ABS_36=::95

  libinput:name:*Apple SPI Touchpad*:dmi:*
    LIBINPUT_MODEL_APPLE_TOUCHPAD=1
    LIBINPUT_ATTR_KEYBOARD_INTEGRATION=internal
    LIBINPUT_ATTR_TOUCH_SIZE_RANGE=200:150
    LIBINPUT_ATTR_PALM_SIZE_THRESHOLD=1200
  '';

  time.timeZone = "Asia/Ho_Chi_Minh";
  i18n.consoleFont = "latarcyrheb-sun32";
  i18n.consoleKeyMap = "dvp";
  i18n.defaultLocale = "en_NZ.UTF-8";

  environment.systemPackages = with pkgs; [
    git
  ];
}
