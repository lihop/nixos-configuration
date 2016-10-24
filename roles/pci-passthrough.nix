{ config, pkgs, ... }:

{
  boot.extraModulePackages = [ ];
  boot.kernelParams = [
    "intel_iommu=on"
    "hugepages=4096"
  ];

  boot.initrd.kernelModules = [
    "vfio"
    "vfio_iommu_type1"
    "vfio_pci"
    "vfio_virqfd"
  ];

  boot.kernelModules = [
    "kvm-intel"
    "virtio"
  ];

  #1002:679a,1002:aaa0
  boot.extraModprobeConfig = ''
    options vfio-pci ids=1002:683d,1002:aab0,8086:1e20,8086:1e31,8086:1e2d,14e4:16b1,1106:3044,8086:1e26
  '';

  environment.systemPackages = with pkgs; [
    OVMF
    virtmanager
  ];

  environment.etc."libvirt/qemu.conf".text = ''
    nvram = [
      "${pkgs.OVMF}/FV/OVMF_CODE.fd:${pkgs.OVMF}/FV/OVMF_VARS.fd"
    ]
  '';

  virtualisation.libvirtd = {
    enable = true;
    enableKVM = true;
  };

  networking.firewall.checkReversePath = false;
}
