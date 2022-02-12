# `eng`: the Microsoft infrastructure to build Go

This directory contains build infrastructure files that Microsoft uses to build
Go Docker images.

The directory name, "eng", is short for "engineering". This name is used because
it matches the engineering directory used in microsoft/go, and also because
auto-updates to the "eng/common" directory only work with this absolute
location.

## Prerequisites

* [PowerShell 6+](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell)

## Building the Docker images

To build a specific docker image, run `docker build .` in a directory that
contains a Dockerfile.

To build all Docker tags in this repository, run `pwsh eng/build.ps1` in the
root of the repo, or `pwsh build.ps1` in `eng`.

## Updating the Dockerfiles

Get the update tool, and view its help doc:

```sh
go install github.com/microsoft/go-infra/cmd/dockerupdate@latest
dockerupdate -h
```

To generate the Dockerfiles, the command has additional prerequisites:
* `bash`
* `awk`
* `jq`

This script wraps the upstream script `/apply-templates.sh`, reusing its
functionality. This also imposes the `jq` and `awk` requirements. Using the
upstream script makes it more likely that this repo will stay up to date when
the templates change in the upstream repo.

The Dockerfiles are checked into the repo after every update, so running this
script is not necessary to simply build the Docker images.

It may seem unusual that even though our Dockerfiles are created by a script
based on a JSON file, they are also checked in. This is done to match the
standard approach to Docker: Dockerfiles are *always* checked in, enabling users
to easily run `docker build .` to reproduce the result without complicated
repo-specific tooling being involved.

### Updating to a new build of Go

Scripted update is another `dockerupdate` feature. Use the `-build-asset-json`
arg to point at a build asset JSON file from a microsoft/go build.

Auto-update after a new microsoft/go build is implemented in microsoft/go-infra:
https://github.com/microsoft/go-infra/blob/main/eng/pipelines/go-update.yml

## Change containment

This repository uses patch files in the `patches` directory, like microsoft/go.
For more information:
https://github.com/microsoft/go/blob/microsoft/main/eng/README.md#patch-files
