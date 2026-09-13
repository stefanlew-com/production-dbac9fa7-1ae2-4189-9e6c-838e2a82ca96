{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.project.browsers.chromium;
  chromium = lib.getExe pkgs.chromium;
  chromedriver = "${pkgs.chromedriver}/bin/chromedriver";
in
{
  options.project.browsers.chromium.enable =
    lib.mkEnableOption "Chromium with a matching chromedriver";

  config = lib.mkIf cfg.enable {
    packages = [
      pkgs.chromium
      pkgs.chromedriver
    ];

    env = {
      CHROME_BIN = lib.mkDefault chromium;
      CHROMEWEBDRIVER = lib.mkDefault (builtins.dirOf chromedriver);
    };

    project.browsers.exports.chromium = {
      binary = chromium;
      driver = chromedriver;
      capability = {
        browserName = "chromium";
        "goog:chromeOptions" = {
          binary = chromium;
          args = [ "--headless=new" ];
        };
        "wdio:chromedriverOptions".binary = chromedriver;
      };
    };
  };
}
