{ config, lib, pkgs, ... }:

{
  options.project.providers.aws.enable = lib.mkEnableOption "the AWS CLI";

  config.packages =
    [ pkgs.git ]
    ++ lib.optional config.project.providers.aws.enable pkgs.awscli2;
}
