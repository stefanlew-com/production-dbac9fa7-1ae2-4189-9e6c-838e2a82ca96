{ lib, pkgs, ... }:

let
  version = "1.4.0";
in
{
  imports = [
    ./aws.nix
    ./browsers
  ];

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
