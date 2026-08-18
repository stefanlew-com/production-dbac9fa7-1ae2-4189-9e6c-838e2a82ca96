# project-kit

A devenv module for project repositories.

## Usage

In your `devenv.yaml`:

```yaml
inputs:
  project-kit:
    url: github:stefanlew-com/production-dbac9fa7-1ae2-4189-9e6c-838e2a82ca96/v1.2.0
    flake: false
imports:
  - project-kit/modules
```

In your `devenv.nix`:

```nix
{
  project.providers.aws = {
    enable = true;
    region = "eu-central-1";

    ssoSession.corp = {
      sso_start_url = "https://d-1234567890.awsapps.com/start";
    };

    profile.default = {
      sso_session = "corp";
      sso_account_id = "111122223333";
      sso_role_name = "AWSReadOnlyAccess";
    };

    profile.deploy = {
      role_arn = "arn:aws:iam::444455556666:role/DeploymentRole";
      credential_source = "Environment";
      region = "us-east-1";
    };
  };
}
```

## Options

| Option | Default | Effect |
|---|---|---|
| `project.environment` | — | Deploy target, supplied by the build pipeline. |
| `project.providers.aws.enable` | `false` | Adds `awscli2`. |
| `project.providers.aws.profile.<name>` | `{ }` | `[profile <name>]`; the name `default` renders as `[default]`. |
| `project.providers.aws.ssoSession.<name>` | `{ }` | `[sso-session <name>]`. |
| `project.providers.aws.region` | `null` | Fallback `region` for profiles, `sso_region` for sessions. |
| `project.providers.aws.output` | `"json"` | Fallback `output` for profiles. |
| `project.providers.aws.pager` | `""` | Fallback `cli_pager` for profiles. Empty disables the pager. |

Keys are written as [AWS defines them](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html)
and a section always wins over a fallback. Sessions also default
`sso_registration_scopes` to `sso:account:access`, the minimum that yields a
refresh token.

## The generated file

Declaring a profile or session points `AWS_CONFIG_FILE` at a file in the Nix
store. Nothing is written to the repository or to `$HOME`.

- It is read-only, so `aws configure set` and `aws configure sso` fail. Edit
  `devenv.nix` instead.
- It is read instead of `~/.aws/config`, not alongside it, so every profile you
  need in the shell has to be declared here. `~/.aws/credentials` is a separate
  file and still applies.
- `aws sso login` is unaffected; its tokens live in `~/.aws/sso/cache`, keyed by
  session name, so an existing login is reused.

No `AWS_*` variable other than `AWS_CONFIG_FILE` is set or cleared.

## Versioning

[SemVer 2.0](https://semver.org/), tagged `vX.Y.Z`. Tags are immutable and there
is no moving major tag — pin an exact version and bump it deliberately.
