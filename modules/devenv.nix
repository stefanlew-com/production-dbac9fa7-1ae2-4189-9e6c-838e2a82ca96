{ config, lib, pkgs, ... }:

{
  options.project = {
    environment = lib.mkOption { type = lib.types.str; };
    providers.aws.enable = lib.mkEnableOption "the AWS CLI";
  };

  config.packages =
    [ pkgs.git ]
    ++ lib.optional config.project.providers.aws.enable pkgs.awscli2;
}
