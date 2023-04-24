# This module optimizes for non-interactive deployments by remove some store paths
# which are primarily useful for interactive installations.

{ config, lib, ... }: {
  disabledModules = [
    # This module adds values to multiple lists (systemPackages, supportedFilesystems)
    # which are impossible/unpractical to remove, so we disable the entire module.
    "profiles/base.nix"
  ];

  # among others, this prevents carrying a stdenv with gcc in the image
  system.extraDependencies = lib.mkForce [];


  # prevents shipping nixpkgs, unnecessary if system is evaluated externally
  nix.registry = lib.mkForce {};

  # would pull in nano
  programs.nano.syntaxHighlight = lib.mkForce false;

  # prevents nano, rsync, strace
  environment.defaultPackages = lib.mkForce [];

  # zfs support is accidentally disabled by excluding base.nix, re-enable it
  boot = {
    kernelModules = [ "zfs" ];
    extraModulePackages = [ config.boot.kernelPackages.zfs ];
  };
}
