# Docker images containing the Microsoft build of Go

This repository creates Docker images that contain the Microsoft build of Go produced by the [microsoft/go](https://github.com/microsoft/go) repository. The tags are published on the Microsoft Artifact Registry (MAR), formerly Microsoft Container Registry (MCR), in the `oss/go/microsoft/golang` repository.

The images produced by this repository are for general use within Microsoft and to help produce FIPS-compliant Go apps. For other purposes, we recommend using the [Docker Hub golang official images](https://hub.docker.com/_/golang).

For more information about building FIPS-compatible Go apps with the Microsoft build of Go tools, visit the [FIPS readme] and [user guide](https://github.com/microsoft/go/blob/microsoft/main/eng/doc/fips/UserGuide.md) in the microsoft/go repository.

## Support

GitHub issues for microsoft/go-images are maintained in the [microsoft/go](https://github.com/microsoft/go) project. For help and questions about the Microsoft build of Go images, please [file an issue in microsoft/go](https://github.com/microsoft/go/issues/new/choose).

The supported tags in this repository are rebuilt approximately twice a week to update base image and distro package dependencies.

## Recommended tags

The tag we recommend for use inside Microsoft is the Go 1.24 Azure Linux 3.0 tag with the `fips` helper enabled.
This sets the `GOEXPERIMENT` environment variable to `systemcrypto`.
(See [What is `-fips`?](docs/tags.md#what-is--fips))

```
mcr.microsoft.com/oss/go/microsoft/golang:1.24-fips-azurelinux3.0
```

The 1.25 tags no longer support a `-fips` variant, because `systemcrypto` is enabled by default in the Microsoft build of Go as of Go 1.25.
For more background information about this change, see [Microsoft build of Go 1.25 crypto backend changes](https://devblogs.microsoft.com/go/microsoft-go-defaults-to-system-crypto/).

We recommend using these tags in the `build` stage of a [multi-stage Dockerfile](https://docs.docker.com/develop/develop-images/multistage-build/).
The final stage should be based on a minimal image.
This avoids unnecessarily deploying build-time dependencies to production.
However, it doesn't necessarily break compliance to use this tag in the final (or only) stage.

To comply with internal Microsoft cryptography policy, a Linux Go app must run in a container with a system-wide OpenSSL library.
The right image to use may depend on your organization or it may need to be custom-built to include product-specific runtime dependencies.
More guidance is available at [Containers Secure Supply Chain - Selecting base images (internal Microsoft link)](https://eng.ms/docs/more/containers-secure-supply-chain/images).

> [!IMPORTANT]
> Our `1.24-fips-bullseye` (Debian) tag and other Debian tags are capable of building a FIPS compliant Go app, but contain a copy of OpenSSL that is **not** FIPS certified.
> These tags are suitable for a `build` stage, but not for FIPS-compliant deployment.

## Tag organization

To view the full list of available Go tags in MAR:

* Visit [`golang` on the MAR Discovery Portal][MAR] (*Microsoft internal auth required*)
  * You must be currently signed into the MAR discovery portal with Microsoft internal auth to see the golang image. If you see a "not found" page, make sure you are signed in at the top-right corner of the MAR page, **then close the tab and click the [`golang`][MAR] link again**.
  * Go to the `Tags` tab to find a filterable list of tags and expand one to see the command to use to pull it.
* Use the [Microsoft Artifact Registry API](https://mcr.microsoft.com/v2/oss/go/microsoft/golang/tags/list)
  * The full tag URL is `mcr.microsoft.com/{name}:{tag}`

See [Tags of microsoft/go-images](docs/tags.md) for more information about tag support, more tag names, and the purpose of each image.

> [!NOTE]
> We don't build any Alpine images. See [microsoft/go#446](https://github.com/microsoft/go/issues/446).

## Is this repository a fork?

We think it's accurate to call this repository a fork of the official Golang image repository, [docker-library/golang](https://github.com/docker-library/golang). The branches here do not share Git ancestry with docker-library/golang. However, the repository serves the same purpose as a Git fork: maintaining a modified version of the Go source code over time.

The submodule named `go` contains the official image source code. The templates in `go` are used to create the Dockerfiles in this repo, at [`src/microsoft`](src/microsoft). See the [eng README file](eng) for more information about this repository's infrastructure.

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

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft 
trademarks or logos is subject to and must follow 
[Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general).
Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship.
Any use of third-party trademarks or logos are subject to those third-party's policies.

[FIPS readme]: https://github.com/microsoft/go/tree/microsoft/main/eng/doc/fips
[MAR]: https://mcr.microsoft.com/en-us/product/oss/go/microsoft/golang/about
