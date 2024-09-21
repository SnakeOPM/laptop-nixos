{ config, pkgs, ... }:
{
  programs.zsh.enable = true;
  environment.pathsToLink = [ "/share/zsh" ];
  users.mutableUsers = true;
  users.groups = {
    larine.gid = config.users.users.larine.uid;
  };
  users.users = {
    root = {
      initialHashedPassword = "$y$j9T$4TEnn2nI5.wvd0kfqc5Cm1$.9L97/RYhqf78lV3Yn23YlCIbbYCWMLV.iMzyZwSF7/";
    };
    larine = {
      isNormalUser = true;
      uid = 1000;
      home = "/home/larine";
      description = "Salyami";
      initialHashedPassword = "$y$j9T$4TEnn2nI5.wvd0kfqc5Cm1$.9L97/RYhqf78lV3Yn23YlCIbbYCWMLV.iMzyZwSF7/";
      extraGroups = [
        "larine"
        "wheel"
      ];
      shell = pkgs.zsh;
    };
  };
}
