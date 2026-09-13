{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.project.browsers.firefox;
  firefox = lib.getExe pkgs.firefox;
  geckodriver = "${pkgs.geckodriver}/bin/geckodriver";
in
{
  options.project.browsers.firefox.enable = lib.mkEnableOption "Firefox with geckodriver";

  config = lib.mkIf cfg.enable {
    packages = [
      pkgs.firefox
      pkgs.geckodriver
    ];

    env = {
      FIREFOX_BIN = lib.mkDefault firefox;
      GECKOWEBDRIVER = lib.mkDefault (builtins.dirOf geckodriver);
    };

    project.browsers.exports.firefox = {
      binary = firefox;
      driver = geckodriver;
      capability = {
        browserName = "firefox";
        "moz:firefoxOptions" = {
          binary = firefox;
          args = [ "-headless" ];
        };
        "wdio:geckodriverOptions".binary = geckodriver;
      };
    };
  };
}
