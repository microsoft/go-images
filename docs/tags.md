# Tags of microsoft/go-images

This repository's build infrastructure is based on the .NET Docker tooling. The Microsoft Go tagging practices are largely the same as .NET Docker's, and we both strive to align with the official Docker image tagging practices.

See [.NET Supported Tags](https://github.com/dotnet/dotnet-docker/blob/main/documentation/supported-tags.md) for .NET Docker's description of this tagging strategy. This document is based on .NET's, but describes the Microsoft Go tags.

# Simple tags

In go-images, a *simple tag* references the image for a specific version of Go, on a specific OS, on a specific platform. The only way to be more specific about a Go image is to use a digest instead of a tag.

In general, we don't recommend using these in Dockerfile `FROM` statements. It prevents auto-update to the latest, patched, images. It also prevents the Dockerfile from working on multiple architectures (`amd64`/`arm64`) when it otherwise might.

Examples:

* `1.19.7-1-bullseye-amd64`
* `1.19.7-1-fips-cbl-mariner1.0-amd64`

> This document uses `1.19.7-1` as a placeholder for *the most recent release of Microsoft Go*. Check MAR for the actual latest tag versions and available OS/Distros.

# Shared tags

A *shared tag* references images for multiple platforms. When used in a Dockerfile or a Docker command, Docker downloads the correct image for the current platform from the list of images pointed to by the shared tag. Shared tags are generally manifest tags.

In some cases there is no single correct choice: the `1.19` tag could download a CBL-Mariner image or a Debian Bullseye image, and could download `1.19.7-1` or `1.19.2-1`. The shared tags represent our recommendation for that particular tag name.

The Go shared tags have these characteristics:

* Include all architectures that we build.
* When no OS/Distro is specified in the tag, use the most recent Debian distribution.
* When a part of the version number is omitted, the most recent matching version is used.

Examples:

* `1.19-bullseye`
* `1.19-fips-cbl-mariner1.0`
* `1`

# Tag parts

* `1.{major}.{minor}-{revision}{extra}-{os/distro}-{architecture}`
  * `major` and `minor` describe the version of the official Go source code that was used. This is not semver: we use upstream Go's definition of `major` and `minor` versions.
  * `revision` is the Microsoft revision of Go.
    * This is incremented when Microsoft needs to release a new microsoft/go build but upstream hasn't released a new version yet.
    * This is *not* incremented when there are Dockerfile-specific changes, base images change, or when platforms are added and removed.
  * `extra` is optional, indicating the image is specialized for a particular scenario.
    * `-fips` is the only `extra` as of writing.
  * `os/distro` is the OS or Linux distribution of the base image.
  * `architecture` is the platform architecture of the image, e.g. `amd64`.

## What is `-fips`?

If a tag includes `-fips`, that indicates that Go build commands inside the container will set the `GOEXPERIMENT` environment variable to use a FIPS-compatible crypto backend by default. Be careful: this isn't the only step necessary to build a FIPS-compliant app. See the [FIPS readme] for more information about `GOEXPERIMENT` and FIPS.

You don't need to use a `-fips` tag to build a FIPS-compliant app: you can use the non`-fips` image and set `GOEXPERIMENT` yourself. The Go toolset is the same in both images. We provide a `-fips` tag to minimize the changes necessary to make an existing Dockerfile build a FIPS-compliant app.

**In Go 1.18 and earlier**, the `-fips` image contained a different branch of Go that was capable of building FIPS-compliant apps, and non`-fips` tags weren't able to build FIPS-compliant apps. `GOEXPERIMENT` was not involved in producing FIPS apps at this time. See the [FIPS readme] for more details.

# Tag lifecycle

The Go versions supported by this repo follow the support lifecycle of [microsoft/go](https://github.com/microsoft/go), which generates the Go binaries used in this repository. OS versions are supported until the OS is EOL. When a tag's Go support or OS support ends, the tag is no longer supported and we delete the Dockerfile when it's convenient to do so.

The microsoft/go-images repository has two active branches:

* `microsoft/main`
  * Tags produced by this branch are published to MAR.
  * This branch is built when there is a new, stable release of microsoft/go, the underlying OS has a change that is important to users of the Microsoft Go images, or the Dockerfile itself is updated. When it's feasible, we only publish tag updates when the image content needs to be updated, to avoid unnecessary build churn downstream.
  * The Dockerfiles in this branch will normally match the images available on MAR, but this may not always the case. Before a release, we need to check in changes to `microsoft/main` before we can officially build them. We also may check in changes further in advance of a release so they are included when the next release eventually happens.
* `microsoft/nightly`
  * Tags produced by this branch are published to an ACR we maintain, not MAR.
  * This branch is frequently updated to new non-production-quality builds of Go. For example, the branch may contain bugfixes that have been committed to a Go release branch, even though the commits aren't part of any release yet. 
  * Actual rate of updates varies: not necessarily nightly. `nightly` is just terminology borrowed from .NET, used to indicate this is not the stable branch.

## Policy Changes

In the event that a change is needed to the tagging patterns we use, all tags for the previous pattern will continue to be supported for their original lifetime.

[FIPS readme]: https://github.com/microsoft/go/tree/microsoft/main/eng/doc/fips
