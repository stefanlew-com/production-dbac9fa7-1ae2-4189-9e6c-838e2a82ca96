{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.project.providers.aws;

  section = lib.types.attrsOf lib.types.str;

  header = name: if name == "default" then "default" else "profile ${name}";

  fallbacks = lib.filterAttrs (_: value: value != null) {
    region = cfg.region;
    output = cfg.output;
    cli_pager = cfg.pager;
  };

  sessionFallbacks = lib.filterAttrs (_: value: value != null) {
    sso_region = cfg.region;
    sso_registration_scopes = "sso:account:access";
  };

  sections =
    lib.mapAttrs' (name: value: lib.nameValuePair (header name) (fallbacks // value)) cfg.profile
    // lib.mapAttrs' (
      name: value: lib.nameValuePair "sso-session ${name}" (sessionFallbacks // value)
    ) cfg.ssoSession;

  configFile = (pkgs.formats.ini { }).generate "aws-config" sections;
in
{
  options.project.providers.aws = {
    enable = lib.mkEnableOption "the AWS CLI";

    region = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };

    output = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = "json";
    };

    pager = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = "";
    };

    profile = lib.mkOption {
      type = lib.types.attrsOf section;
      default = { };
    };

    ssoSession = lib.mkOption {
      type = lib.types.attrsOf section;
      default = { };
    };
  };

  config = {
    packages = lib.optional cfg.enable pkgs.awscli2;

    env = lib.mkIf (cfg.enable && sections != { }) {
      AWS_CONFIG_FILE = lib.mkDefault "${configFile}";
    };
  };
}
