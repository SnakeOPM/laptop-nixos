{ pkgs, ... }:
{
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      slurp
      hyprshot
      home-manager
      thefuck
      ;
  };
}
