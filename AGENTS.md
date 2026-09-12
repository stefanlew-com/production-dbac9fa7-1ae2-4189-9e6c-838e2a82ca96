# project-kit

The devenv module that managed project repositories import. Its options and their
effects are in [`README.md`](./README.md).

A repository is deployed by the build pipeline, which runs exactly one command:

```sh
devenv shell -O project.environment:string "$PROJECT_ENVIRONMENT" -- deploy
```

Everything happens inside `devenv shell` as the repository's `deploy` script; the
pipeline does not care what the project is built with, only that `deploy` exists.
Importing this module is enough — it declares the `project.environment` option the
command sets.

The module installs a `project-kit` command for anything else the pipeline needs,
so future additions land under it instead of as new top-level scripts. Today that
is only the version, which the pipeline may call to learn which contract to apply:

```sh
devenv shell -- project-kit --version
```

It prints the exact project-kit version as a bare semver; a repository without the
command is treated as the 1.x contract.

The target account, credentials and the project id are pipeline provided and
injected automatically: resolve them through the normal AWS credential chain,
never static keys. Do not hardcode the account; it is not repository config.

project-kit follows SemVer and reports it through `project-kit --version`, so the
pipeline can tell majors apart without guessing. All 1.x share the current
contract; a later major won't break them, and newer docs apply to an older pin in
parts but never invalidate it.
