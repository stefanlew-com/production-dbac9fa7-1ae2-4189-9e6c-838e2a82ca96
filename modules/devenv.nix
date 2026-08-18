{ lib, pkgs, ... }:

{
  imports = [ ./aws.nix ];

  options.project.environment = lib.mkOption { type = lib.types.str; };

  config.packages = [ pkgs.git ];
}
