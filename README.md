# Docker images containing the Microsoft build of Go

This repository creates Docker images that contain the Microsoft build of Go produced by the [microsoft/go](https://github.com/microsoft/go) repository. The tags are published on the Microsoft Artifact Registry (MAR), formerly Microsoft Container Registry (MCR), in the `oss/go/microsoft/golang` repository.

The images produced by this repository are for general use within Microsoft and to help produce FIPS-compliant Go apps. For other purposes, we recommend using the [Docker Hub golang official images](https://hub.docker.com/_/golang).

For more information about building FIPS-compatible Go apps with the Microsoft Go tools, visit the [FIPS readme] and [user guide](https://github.com/microsoft/go/blob/microsoft/main/eng/doc/fips/UserGuide.md) in the microsoft/go repository.

## Support

GitHub issues for microsoft/go-images are maintained in the [microsoft/go](https://github.com/microsoft/go) project. For help and questions about the Microsoft Go images, please [file an issue in microsoft/go](https://github.com/microsoft/go/issues/new/choose).

The supported tags in this repository are rebuilt approximately twice a week to update base image and distro package dependencies.

## Recommended tags

In general, the microsoft/go-images tag names match those available for the official images. To switch from the official image to one on MCR, it may be possible to simply prepend `mcr.microsoft.com/oss/go/microsoft/` to the official image you would normally use.

This tag is recommended for general build scenarios where FIPS compliance is not required:

```
mcr.microsoft.com/oss/go/microsoft/golang:1.22-cbl-mariner2.0
```

To build a FIPS-compliant app, we recommend writing a [multi-stage Dockerfile](https://docs.docker.com/develop/develop-images/multistage-build/) that uses a `fips` tag in the `build` stage and copies the built Go app into the final stage. We recommend using a minimal CBL-Mariner container for the final stage.

This Azure Linux (Mariner) `fips` tag is recommended for the `build` stage of a Dockerfile:

```
mcr.microsoft.com/oss/go/microsoft/golang:1.22-fips-cbl-mariner2.0
```

For the final stage of the multi-stage Dockerfile, an image with a FIPS certified OpenSSL library is necessary. The right image to use may depend on your organization or need to be assembled.

For Microsoft teams building containers, more guidance is available at [Containers Secure Supply Chain - Selecting base images (internal Microsoft link)](https://eng.ms/docs/more/containers-secure-supply-chain/images).

See [What is `-fips`?](docs/tags.md#what-is--fips) for more details about the meaning of `fips` in a tag name.

> [!IMPORTANT]
> Our `azurelinux3.0` tags can't be used to to run (deploy) a FIPS-compliant Go app.
> See [https://aka.ms/azurelinux3 (internal Microsoft link)](https://aka.ms/azurelinux3) for current information about Azure Linux 3.0 and the implications for FIPS compliance.
> (Last update: 2024-08-29.)

> [!IMPORTANT]
> Our `1.22-fips-bullseye` (Debian) tag and other Debian tags are capable of building a FIPS compliant Go app, but contain a copy of OpenSSL that is **not** FIPS certified.
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
