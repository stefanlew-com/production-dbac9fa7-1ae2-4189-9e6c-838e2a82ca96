{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.project.browsers;

  names = lib.attrNames cfg.exports;

  module = pkgs.linkFarm "project-kit-browsers" {
    "index.mjs" = pkgs.writeText "index.mjs" ''
      ${lib.concatMapStrings (
        name: "export const ${name} = ${builtins.toJSON cfg.exports.${name}};\n"
      ) names}
      export const browsers = [ ${lib.concatStringsSep ", " names} ];
    '';

    "index.d.mts" = pkgs.writeText "index.d.mts" ''
      export interface Browser {
        readonly binary: string;
        readonly driver: string;
        readonly capability: { readonly browserName: string; readonly [key: string]: unknown };
      }

      ${lib.concatMapStrings (name: "export const ${name}: Browser;\n") names}
      export const browsers: readonly Browser[];
    '';
  };

  stateDir = "${config.devenv.state}/project-kit";
in
{
  imports = [
    ./chromium.nix
    ./firefox.nix
  ];

  options.project.browsers.exports = lib.mkOption {
    type = lib.types.attrsOf lib.types.raw;
    default = { };
    internal = true;
  };

  config = lib.mkIf (cfg.exports != { }) {
    tasks."project-kit:browsers" = {
      exec = ''
        mkdir -p ${lib.escapeShellArg stateDir}
        ln -sfn ${module} ${lib.escapeShellArg "${stateDir}/browsers"}
      '';
      before = [ "devenv:enterShell" ];
    };
  };
}
