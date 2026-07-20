# Docker images containing the Microsoft build of Go

This project maintains [`mcr.microsoft.com/oss/go/microsoft/golang`](https://mcr.microsoft.com/artifact/mar/oss/go/microsoft/golang/about), a repository of Docker images that contain the [Microsoft build of Go](https://github.com/microsoft/go).
This repository is hosted by the [Microsoft Artifact Registry (MAR, formerly MCR)](https://mcr.microsoft.com/), a public container registry for Microsoft projects.

The images produced by this repository are intended for general use within Microsoft and to help produce FIPS-compliant Go apps.
For other purposes, we recommend using the [Docker Official Image `golang`](https://hub.docker.com/_/golang).

The [**Migration Guide** for the Microsoft build of Go][Migration Guide] contains additional information.

## Support

See [SUPPORT.md](SUPPORT.md) for more information about reporting bugs, requesting features, and asking questions.

There are a few additional support resources internal to Microsoft:

* [(Microsoft-internal) Languages at Microsoft: Introduction to Go](https://eng.ms/docs/more/languages-at-microsoft/go/articles/overview).
* [(Microsoft-internal) Languages at Microsoft: Get Help with Go](https://eng.ms/docs/more/languages-at-microsoft/go/articles/support).
  * Includes internal Microsoft support channels such as an email contact for our team and a community Teams group.

## Release cycle and policy

New images are built and published when a new release of the Microsoft build of Go is available.
The images are published before the new release is announced.
See the [Microsoft build of Go release cycle and policy](https://github.com/microsoft/go/tree/microsoft/main#release-cycle-and-policy).

New images are also built approximately twice a week to update base image and distro package dependencies.
This occurs even when the Microsoft build of Go has not been updated.

## Recommended tags

The tag we recommend for Go projects inside Microsoft that are migrating to the Microsoft build of Go is [the 1.25 Azure Linux 3.0 tag](https://mcr.microsoft.com/en-us/artifact/mar/oss/go/microsoft/golang/tag/1.25).

```
mcr.microsoft.com/oss/go/microsoft/golang:1.25-azurelinux3.0
```

We also recommend moving from 1.25 to 1.26 as soon as possible.
This way, you can detect bugs that have to do with the new Go version as soon as possible and maximize the time remaining to address them before 1.25 is out of support.

If your project is already using 1.26, use the 1.26 tag.

A `1.X` tag contains the latest version of the Microsoft build of Go for that `X` version.

> [!NOTE]
> Both the N (1.26) and N-1 (1.25) releases of Go are supported, so why do we recommend starting with the N-1 release?
>
> A new version of Go may have breaking changes that require you to change your project.
> Also, when a new Go version N just comes out (1.26.0), it may have some initial bugs that will be fixed in the next handful of patches.
> Therefore, we recommend that if you don't have a reason to pick a specific version, start with N-1 to avoid compatibility issues that might delay your migration to the Microsoft build of Go.
>
> We also encourage upgrading from N-1 to N as soon as possible, so that any compatibility issues can be detected and addressed before N-1 is out of support.
> Otherwise, compatibility issues may compound with security issues, causing delays in your project's ability to address security vulnerabilities.

> [!NOTE]
> Go libraries should be compatible with both N-1 and N to leave the choice up to the library's users.
> Testing against both N-1 and N is recommended.

## Usage

### Building a Go project

If you use a Dockerfile, we recommend using `mcr.microsoft.com/oss/go/microsoft/golang` tags in the `build` stage of a [multi-stage Dockerfile](https://docs.docker.com/develop/develop-images/multistage-build/).
The final stage in the Dockerfile should be based on a minimal image.
This avoids unnecessarily deploying build-time dependencies to production.

These tags are also suitable for use in an [Azure Pipelines container job](https://learn.microsoft.com/azure/devops/pipelines/process/container-phases?view=azure-devops) that builds a Go project.

See the [Migration Guide][Migration Guide].

### Deploying a container image

The `mcr.microsoft.com/oss/go/microsoft/golang` tags may not be suitable for deployment.
To comply with internal Microsoft cryptography policy, a Linux Go app must run in a container with a system-wide OpenSSL library.
If you need FIPS compliance, there are additional requirements.
See the [Migration Guide][Migration Guide].

The right image to use may depend on your organization, or it may need to be custom-built to include product-specific runtime dependencies.

> [!IMPORTANT]
> Our `1.25-bullseye` (Debian) tag and other Debian tags are capable of building a FIPS-compliant Go app, but they contain a copy of OpenSSL that is **not** FIPS certified.
> These tags may be suitable for a `build` stage, but not for FIPS-compliant deployment.

### Using image digests to pin a specific image

You can use a digest to pin a container image dependency to a specific immutable version.
See the ["Image digests" Docker documentation](https://docs.docker.com/dhi/core-concepts/digests/).

Docker container image tags are mutable, meaning that the same tag may point to different image versions over time.
Even a tag with a fully specified Go version may change, e.g. when we build a new version with updated OS dependencies.
Unlike image tags, image digests are immutable.

In general, pinning dependencies is good, and Docker container tags are no exception.
It has security benefits, and it means problems show up in dependency upgrade PRs rather than breaking a production build.

See [Image digests](docs/image-digests.md) for information about using image digests with the Microsoft build of Go.
This page contains two ways to get digests, and how to use digests to roll back to a previous image version.

Unfortunately, there are currently a few feature gaps in the infrastructure that lead us to not consider image digests feasible for everyday use.
Fixing some combination of these limitations would let us recommend using digests in more situations:

* Dependabot is unable to upgrade a digest outside of Dockerfiles. ([Internal tracking issue](https://github.com/microsoft/go-lab/issues/479))
  * For example, it can't update Azure Pipelines container job image references.
* Azure Pipelines container jobs can't use a Dockerfile as the dependency of a container job. ([Internal tracking issue](https://github.com/microsoft/go-lab/issues/477))
* Microsoft internal Dependabot is unable to upgrade a dependency on our container images to a new digest. ([Internal tracking issue](https://github.com/microsoft/go-lab/issues/476))
  * There appears to be an allowlist that doesn't include our tags.

There are alternative dependency upgrade tools without the limitations mentioned above, but they don't seem to be widely used inside Microsoft.
([Internal tracking issue](https://github.com/microsoft/go-lab/issues/478))

## Tag organization

To view the full list of available Go tags in MAR, visit [`golang` on the MAR Discovery Portal][MAR].
Go to the `Tags` tab to find a filterable list of tags and expand one to see the command to use to pull it.

See [Tags of microsoft/go-images](docs/tags.md) for more information about tag support, more tag names, and the purpose of each image.

> [!NOTE]
> If you've used our 1.24 or earlier images, you may expect to see a `-fips` variant.
> As of 1.25, we no longer produce `-fips` tags, because `systemcrypto` is enabled by default in the Microsoft build of Go as of Go 1.25.
> Basically: the change that was previously in the `-fips` images is now present in all of our ordinary images.
>
> For more background information about this change, see [Microsoft build of Go 1.25 crypto backend changes](https://devblogs.microsoft.com/go/microsoft-go-defaults-to-system-crypto/).

> [!NOTE]
> We don't build any Alpine images. See [microsoft/go#446](https://github.com/microsoft/go/issues/446).

> [!TIP]
> Prefer raw data?
> Try the [Microsoft Artifact Registry API tag list for `golang`](https://mcr.microsoft.com/v2/oss/go/microsoft/golang/tags/list)

## Is this repository a fork?

We think it's accurate to call this repository a fork of the official Golang image repository, [docker-library/golang](https://github.com/docker-library/golang). The branches here do not share Git ancestry with docker-library/golang. However, the repository serves the same purpose as a Git fork: maintaining a modified version of the Go source code over time.

The submodule named `go` contains the official image source code. The templates in `go` are used to create the Dockerfiles in this repo, at [`src/microsoft`](src/microsoft). See the [eng README file](eng/README.md) for more information about this repository's infrastructure.

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

The [README in `eng`](eng/README.md) contains more information about the build infrastructure for this repository.

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft 
trademarks or logos is subject to and must follow 
[Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general).
Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship.
Any use of third-party trademarks or logos are subject to those third-party's policies.

## Data Collection

The software may collect information about you and your use of the software and
send it to Microsoft. Microsoft may use this information to provide services
and improve our products and services. You may turn off the telemetry by
setting the `MS_GOTOOLCHAIN_TELEMETRY_ENABLED` environment variable to `0`.
There are also some features in the software that may enable you and Microsoft
to collect data from users of your applications. If you use these features,
you must comply with applicable law, including providing appropriate notices to
users of your applications together with a copy of Microsoft’s privacy
statement. Our privacy statement is located at https://go.microsoft.com/fwlink/?LinkID=824704.
You can learn more about data collection and use in the help documentation and
our privacy statement. Your use of the software operates as your consent to
these practices.

[Migration Guide]: https://github.com/microsoft/go/blob/microsoft/main/eng/doc/MigrationGuide.md
[FIPS readme]: https://github.com/microsoft/go/tree/microsoft/main/eng/doc/fips
[MAR]: https://mcr.microsoft.com/product/oss/go/microsoft/golang/about
