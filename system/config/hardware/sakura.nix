{ modulesPath, ... }:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  # bootloader
  boot.loader.grub = {
    enable = true;
    device = "/dev/vda";
    copyKernels = true;
  };

  # tmpfs
  boot.tmp.useTmpfs = false;
  boot.tmp.cleanOnBoot = true;

  # kernel
  boot.initrd.availableKernelModules = [
    "ata_piix"
    "uhci_hcd"
    "ehci_pci"
    "virtio_pci"
    "sr_mod"
    "virtio_blk"
  ];
  boot.kernelParams = [
    "console=ttyS0,115200n8"
    "console=tty0"
  ];

  # arch
  nixpkgs.hostPlatform = "x86_64-linux";

  # optmize
  services.udev.extraRules = ''
    ACTION=="add|change", KERNEL=="vd[a-z]*", ATTR{queue/scheduler}="brq"
  '';
}
