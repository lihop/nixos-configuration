{ config, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.kernelPackages = pkgs.linuxPackages_4_1;

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ehci_pci"
    "ahci"
    "firewire_ohci"
    "usb_storage"
    "usbhid"
    "dm_cache"
  ];

  fileSystems."/" =
    { device = "/dev/mapper/data_crypt";
      fsType = "btrfs";
    };

  fileSystems."/boot" =
    { device = "/dev/mapper/boot_crypt";
      fsType = "btrfs";
    };

  swapDevices = [
    { device = "/dev/mapper/swap_crypt"; }
  ];

  nix.maxJobs = 8;

  boot.loader.grub.enable = true;
  boot.loader.grub.enableCryptodisk = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.devices = [
    "/dev/disk/by-id/ata-ADATA_SP920SS_14100C08F8A2"
    "/dev/disk/by-id/ata-ADATA_SP920SS_14100C08F914"
    "/dev/disk/by-id/ata-ADATA_SP920SS_14100C092FF9"
  ];

  # Setup crypt devices
  boot.initrd.luks.devices = [
    { name = "boot_crypt"; device = "/dev/vg/boot"; preLVM = false; }
    { name = "data_crypt"; device = "/dev/vg/data"; preLVM = false; }
    { name = "swap_crypt"; device = "/dev/vg/swap"; preLVM = false; }
  ];

  services.xserver = {
    videoDrivers = [ "ati_unfree" ];
  };
}
