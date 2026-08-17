# project-kit

A devenv module for project repositories.

## Usage

In your `devenv.yaml`:

```yaml
inputs:
  project-kit:
    url: github:stefanlew-com/production-dbac9fa7-1ae2-4189-9e6c-838e2a82ca96/v1.0.0
    flake: false
imports:
  - project-kit/modules
```

In your `devenv.nix`:

```nix
{
  project.providers.aws.enable = true;
}
```

## Options

| Option | Package |
|---|---|
| `project.providers.aws.enable` | `awscli2` |

## Versioning

[SemVer 2.0](https://semver.org/), tagged `vX.Y.Z`. Tags are immutable and there
is no moving major tag — pin an exact version and bump it deliberately.
