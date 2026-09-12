{ lib, pkgs, ... }:

let
  version = "1.3.0";
in
{
  imports = [ ./aws.nix ];

  options.project.environment = lib.mkOption { type = lib.types.str; };

  config.packages = [ pkgs.git ];

  config.scripts.project-kit.exec = ''
    case "''${1:-}" in
    --version)
      echo "${version}"
      ;;
    *)
      exit 2
      ;;
    esac
  '';
}
