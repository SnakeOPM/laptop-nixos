{
  lib,
  pkgs,
  path,
  ...
}:
{
  imports =
    [
      ### ----------------PROGRAMS------------------- ###
      ./programs/firefox.nix
      (path + /home/shared/programs/spotify.nix)
      ### ----------------PROGRAMS------------------- ###
    ]
    ++ lib.flatten [
      (lib.concatLists [
        (import (path + /home/larine/dev/default.nix))
        (import (path + /home/larine/utils/default.nix))
      ])
    ];
  home = {
    packages = builtins.attrValues {
      inherit (pkgs)
        # Media
        spicetify-cli
        vlc

        # Gaming
        bottles

        # Socials
        mattermost-desktop
        thunderbird

        # Productivity
        libreoffice-fresh
        # libreoffice libreoffice-fresh is better

        # Graphic
        krita
        qbittorrent
        postman
        # neofetch modules/shared/settings 
        # spotify # home/shared/programs/spotify.nix
        # unrar installed by default
        # openvpn use module instead
        # htop installed by default
        # vesktop # home/shared/programs/discord.nix
        # git # home/larine/utils/git.nix
        # vscodium home/larine/dev/vscode.nix
        # go home/larine/dev/vscode.nix
        # firefox-wayland ./programs/firefox.nix
        # appimage-run included by option  
        # wine steam module covers it 
        # nixpkgs-fmt home/larine/dev/vscode.nix

        autorandr # you should move to a different location
        ;
      # dev
      inherit (pkgs) php83 phpunit;
      inherit (pkgs.php83Extensions) xdebug;
      inherit (pkgs.php83Packages) composer;

      # Networking/VPN/Proxy
      inherit (pkgs) nekoray;
      inherit (pkgs.unstable) zapret telegram-desktop;
    };
    stateVersion = "24.05";
  };
}
