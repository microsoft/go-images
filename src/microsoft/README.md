# Dockerfiles for golang images containing the Microsoft build of Go

The Dockerfiles under this directory are based on the official golang
Dockerfiles, but they contain the Microsoft build of Go rather than the official
version. For more information, see [/eng/README.md](/eng/README.md).

## Infrastructure files in this directory

### `jq-template.awk`
A checked-in copy of a file containing utility `awk` code. It's downloaded from
the internet by the root `/apply-templates.sh` script. To avoid this network
dependency while running an update, we check in the file, instead.

To update `jq-template.awk`, run `/apply-templates.sh`, then copy
`/.jq-template.awk` to `/src/microsoft/jq-template.awk`. The symptoms of this
file falling out of date are not known, as of writing.

### `versions.json`
Contains information about the Microsoft builds of Go in the format
`/apply-templates.sh` works with. This is used as the source of truth for
generating the Dockerfiles.

Use the `/eng/update-dockerfiles.sh` script to generate the Dockerfiles based on
this `versions.json` file.

This file is also used to generate `/manifest.json`, the file that drives the
.NET Docker build infrastructure used to build our Docker images. This means
there are some extra things to consider:
* The order of the `variants` array is critical: it must be in dependency order.
  For example, `windows/nanoserver-1809` depends on
  `windows/windowsservercore-1809`, so nanoserver must be later than
  windowsservercore.
* The `preferredMajor` key refers to `1` in `1.16.6`, and should only exist
  once. It determines the version to tag `latest`.
* The `preferredMinor` key refers to `1.16` in `1.16.6`, and should only exist
  once per major version. It determines the version to tag `1`.
* The `preferredVariant` key determines the platform to use in tags that don't
  include a specific platform, like `1.16.6` (vs. `1.16.6-buster`).
