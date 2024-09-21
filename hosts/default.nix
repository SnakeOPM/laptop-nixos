{
  lib,
  inputs,
  self,
  path,
  nixpkgs,
  sops-nix,
  agenix,
  home-manager,
  catppuccin,
  spicetify-nix,
  nur,
  hyprland,
  vscode-server,
  flatpaks,
  aagl,
  ...
}:
let
  systems = import ./mkSystemConfig.nix {
    ### ----------------FLAKE------------------- ###
    inherit lib;
    inherit inputs self path;
    ### ----------------FLAKE------------------- ###  

    ### ----------------SYSTEM------------------- ###
    inherit nixpkgs;
    ### ----------------SYSTEM------------------- ###

    ### ----------------MODULES & OVERLAYS------------------- ###
    inherit agenix sops-nix;
    inherit home-manager spicetify-nix nur;

    ### ----------------DESKTOP------------------- ###
    inherit hyprland;
    ### ----------------DESKTOP------------------- ###

    inherit vscode-server flatpaks;
    inherit catppuccin aagl;
    ### ----------------MODULES & OVERLAYS------------------- ###
  };
  inherit (systems) mkSystemConfig;
in
{
  LarinePortable = mkSystemConfig.linux {
    hostName = "LarinePortable";
    system = "x86_64-linux";
    useHomeManager = true;
    users = [ "larine" ];
  };
}
