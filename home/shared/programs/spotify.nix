{ pkgs, ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      spotify = prev.spotify.overrideAttrs (prev: {
        version = "1.2.25.1011.g0348b2ea";
        rev = 73;
      });
    })
  ];
  programs.spicetify = {
    enable = true;
    colorScheme = "mocha";
    theme = pkgs.spicetify.themes.catppuccin;

    enabledExtensions = builtins.attrValues {
      inherit (pkgs.spicetify.extensions)
        fullAppDisplay
        shuffle # shuffle+ (special characters are sanitized out of ext names)
        hidePodcasts
        copyToClipboard
        adblock
        ;
    };
    enabledCustomApps = builtins.attrValues {
      inherit (pkgs.spicetify.apps)
        marketplace
        localFiles
        historyInSidebar
        betterLibrary
        ;
    };
    alwaysEnableDevTools = true;
    spotifyLaunchFlags = "--show-console";
  };
}
