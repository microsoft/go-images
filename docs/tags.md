# Tags of microsoft/go-images

This repository's build infrastructure is based on the .NET Docker tooling. The Microsoft Go tagging practices are largely the same as .NET Docker's, and we both strive to align with the official Docker image tagging practices.

See [.NET Supported Tags](https://github.com/dotnet/dotnet-docker/blob/main/documentation/supported-tags.md) for .NET Docker's description of this tagging strategy. This document is based on .NET's, but describes the Microsoft Go tags.

# Simple tags

In go-images, a *simple tag* references the image for a specific version of Go, on a specific OS, on a specific platform. The only way to be more specific about a Go image is to use a digest instead of a tag.

In general, these shouldn't be used in Dockerfile `FROM` statements. It would prevent auto-update to the latest, patched, images. It also prevents the Dockerfile from working on multiple architectures (`amd64`/`arm64`) when it otherwise might.

Examples:

* `1.17.7-1-bullseye-amd64`
* `1.17.7-1-fips-cbl-mariner1.0-amd64`

> This document uses `1.17.7-1` as a placeholder for *the most recent release of Microsoft Go*. Check MCR for the actual latest tag versions and available OS/Distros.

# Shared tags

A *shared tag* references images for multiple platforms. The Go shared tags have these characteristics:

* Include all architectures that are available in microsoft/go-images.
* When no OS/Distro is specified in the tag, use the most recent Debian distribution.
* When a part of the version number is omitted, the most recent matching version is used.

Examples:

* `1.17-bullseye`
* `1.17-fips-cbl-mariner1.0`
* `1`

# Tag parts

* `1.{major}.{minor}-{revision}{extra}-{os/distro}-{architecture}`
  * `major` and `minor` describe the version of the official Go source code that was used. This is not semver: we use upstream Go's definition of `major` and `minor` versions.
  * `revision` is the Microsoft revision of Go.
    * This is incremented when Microsoft needs to release a new microsoft/go build but upstream hasn't released a new version yet.
    * This is *not* incremented when there are Dockerfile-specific changes, base images change, or when platforms are added and removed.
  * `extra` specifies that the image is specialized for a particular scenario.
    * `-fips` is a only `extra` as of writing. It indicates the image is capable of building FIPS-compatible Go apps.
  * `os/distro` is the OS or Linux distribution of the base image.
  * `architecture` is the platform architecture of the image, e.g. `amd64`.

# Tag lifecycle

The Go versions supported by this repo follow the support lifecycle of [microsoft/go](https://github.com/microsoft/go), which generates the Go binaries used in this repository. OS versions are supported until the OS is EOL. When a tag's Go support or OS support ends, the tag is no longer supported.

The microsoft/go-images repository has two active branches:

* `microsoft/main`
  * This branch is updated when there is a new, stable release of microsoft/go, the underlying OS has a change that is important to users of the Microsoft Go images, or the Dockerfile itself is updated.
  * Tags produced by this branch are published to MCR. 
* `microsoft/nightly`
  * This branch is frequently updated to new non-production-quality builds of Go. For example, the branch may contain bugfixes that have been committed to a Go release branch, even though the commits aren't part of any release yet. 
  * Actual rate of updates varies: not necessarily nightly. `nightly` is just terminology borrowed from .NET, used to indicate this is not the stable branch.
  * The tags produced by this branch are not published to MCR.

## Policy Changes

In the event that a change is needed to the tagging patterns we use, all tags for the previous pattern will continue to be supported for their original lifetime.
