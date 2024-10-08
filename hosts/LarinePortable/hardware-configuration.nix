{
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  boot = {
    kernelPackages = pkgs.unstable.linuxPackages;
    kernelModules = [
      # dkms
      "kvm-intel"
    ];
    # Blacklisted Kernel modules do not change
    blacklistedKernelModules = [
      "i915"
      "amdgpu"
      "nouveau"
    ];
    supportedFilesystems = [ "ntfs" ];
  };
  boot.loader = {
    systemd-boot.enable = true;
    generationsDir.copyKernels = true;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";
  };
  ### ----------------BOOT------------------- ###
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/B204-4A85";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };
  ### ----------------BOOT------------------- ###
  boot.initrd = {
    availableKernelModules = [
      "xhci_pci"
      "ahci"
      "nvme"
      "usbhid"
      "sd_mod"
    ];
    kernelModules = [
      # modules
      "vfat"
      # yubico
      "nls_cp437"
      "nls_iso8859-1"
    ];
  };
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/3ad6e4fe-ddb6-472d-9cd8-5ba838c73012";
    fsType = "ext4";
  };
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.enableRedistributableFirmware = lib.mkDefault true;
}
