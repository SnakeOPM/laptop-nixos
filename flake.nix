{
  description = "laptop config";
  inputs = {
    ### --- Utils --- ###
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-utils.url = "github:numtide/flake-utils";
    devenv.url = "github:cachix/devenv";
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
    ### --- Utils --- ###

    ### --- System --- ###
    ### --- nixpkgs channels --- ###
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    master.url = "github:nixos/nixpkgs/master"; # Only for debug purposes e.g. nix run
    nixpkgs-23_11.url = "github:nixos/nixpkgs/nixos-23.11"; # for ibus
    nixpkgs-23_05.url = "github:nixos/nixpkgs/nixos-23.05"; # for ibus
    ### --- nixpkgs channels --- ###
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    nur.url = "github:nix-community/NUR";
    ### --- System --- ###

    ### --- ESSENTIAL system modules --- ###
    agenix.url = "github:ryantm/agenix";
    sops-nix.url = "github:Mic92/sops-nix";
    flatpaks.url = "github:GermanBread/declarative-flatpak/stable";
    ### --- ESSENTIAL system modules --- ###

    ### --- Overlays and Applications --- ###
    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    doom-emacs.url = "github:nix-community/nix-doom-emacs";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix/master";
    catppuccin.url = "github:catppuccin/nix";
    hyprland.url = "github:hyprwm/Hyprland";
    nixcord.url = "github:KaylorBen/nixcord";
    nixified-ai.url = "github:nixified-ai/flake";

    # devenv dependencies
    nix2container.url = "github:nlewo/nix2container";
    mk-shell-bin.url = "github:rrbutani/nix-mk-shell-bin";

    # Utility apps
    nix-software-center.url = "github:snowfallorg/nix-software-center";
    nixos-conf-editor.url = "github:snowfallorg/nixos-conf-editor";
    # Games
    aagl.url = "github:ezKEa/aagl-gtk-on-nix/release-24.05";

    ### --- Overlays and Applications --- ###

    ### --- De-duplication --- ###
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    doom-emacs.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";
    nixified-ai.inputs.nixpkgs.follows = "nixpkgs";
    nix2container.inputs.nixpkgs.follows = "nixpkgs";
    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";
    doom-emacs.inputs.emacs-overlay.follows = "emacs-overlay";
    ### --- de-duplication --- ###
  };

  outputs =
    {
      self,
      # Utils
      flake-parts,
      flake-utils,
      devenv,
      pre-commit-hooks,
      nixpkgs,
      home-manager,
      catppuccin,
      hyprland,
      sops-nix,
      agenix,
      flatpaks,
      nur,
      aagl,
      spicetify-nix,
      vscode-server,
      ...
    }@inputs:
    let
      path = ./.;
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.devenv.flakeModule ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      perSystem =
        {
          config,
          system,
          pkgs,
          ...
        }:
        {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          checks = {
            pre-commit-check = pre-commit-hooks.lib.${system}.run {
              src = path;
              ## --- NIX related hooks --- ##
              # formatter
              hooks.nixfmt = {
                enable = true;
                excludes = [
                  ".direnv"
                  ".devenv"
                ];
                settings.width = 120;
                package = pkgs.nixfmt-rfc-style;
              };
              ## --- NIX related hooks --- ##
            };
          };
          devenv.shells.default = {
            name = "Flake Environment";
            languages = {
              nix.enable = true;
              shell.enable = true;
            };
            pre-commit = {
              excludes = [
                ".direnv"
                ".devenv"
              ];
              hooks.nixfmt = {
                enable = true;
                excludes = [
                  ".direnv"
                  ".devenv"
                  "pkgs"
                ];
                settings.width = 120;
                package = pkgs.nixfmt-rfc-style;
              };
              hooks.shellcheck.enable = true;
            };
            packages = builtins.attrValues {
              inherit (pkgs) git pre-commit;
              inherit (pkgs) nix-index nix-prefetch-github nix-prefetch-scripts;
            };
          };
          formatter = pkgs.nixfmt-rfc-style;
        };
      flake =
        let
          commonAttrs = {
            inherit (nixpkgs) lib;
            inherit (self) output;
            ### ----------------FLAKE------------------- ###
            inherit inputs self path;
            ### ----------------FLAKE------------------- ###

            ### ----------------SYSTEM------------------- ###
            inherit nixpkgs;
            ### ----------------SYSTEM------------------- ###

            ### ----------------MODULES & OVERLAYS------------------- ###
            inherit hyprland;
            inherit agenix sops-nix;
            inherit home-manager spicetify-nix nur;
            inherit vscode-server flatpaks;
            inherit catppuccin aagl;
            ### ----------------MODULES & OVERLAYS------------------- ###
          };
        in
        {
          nixosConfigurations = import (path + /hosts) commonAttrs;
        };
    };
}
