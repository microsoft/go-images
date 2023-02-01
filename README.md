# Docker images containing the Microsoft build of Go

This repository creates Docker images that contain the Microsoft build of Go produced by the [microsoft/go](https://github.com/microsoft/go) repository. The tags are published on the Microsoft Artifact Registry (MAR), formerly Microsoft Container Registry (MCR), in the `oss/go/microsoft/golang` repository.

The images produced by this repository are for general use within Microsoft and to produce FIPS-compliant Go apps. For other purposes, we recommend using the [Docker Hub golang official images](https://hub.docker.com/_/golang).

For more information about building FIPS-compatible Go apps with the Microsoft Go tools, visit the [FIPS readme] and [user guide](https://github.com/microsoft/go/blob/microsoft/main/eng/doc/fips/UserGuide.md) in the microsoft/go repository.

## Recommended tags

In general, the microsoft/go-images tag names match those available for the official images. To switch from the official image to one on MCR, it may be possible to simply prepend `mcr.microsoft.com/oss/go/microsoft/` to the official image you would normally use.

This tag is recommended for general build scenarios:

```
mcr.microsoft.com/oss/go/microsoft/golang:1.20-bullseye
```

If you need to build a FIPS-compliant app, use a `fips` tag, such as:

```
mcr.microsoft.com/oss/go/microsoft/golang:1.20-fips-cbl-mariner1.0
```

When building a containerized FIPS-compliant app, in general we recommend using a [multi-stage Dockerfile](https://docs.docker.com/develop/develop-images/multistage-build/) that uses our `fips` tag in the builder stage and copies the built Go app into a minimal CBL-Mariner container to produce the final image.

To view the full list of available Go tags in MAR:

* Visit the [AZCU Indexer](https://azcuindexer.azurewebsites.net/repositories/oss/go/microsoft/golang) (*Microsoft internal auth required*)
  * Click on a tag name to copy the full tag URL to your clipboard
* Use the [Microsoft Artifact Registry API](https://mcr.microsoft.com/v2/oss/go/microsoft/golang/tags/list)
  * The full tag URL is `mcr.microsoft.com/{name}:{tag}`

See [Tags of microsoft/go-images](docs/tags.md) for more information about tag support, more tag names, and the purpose of each image.

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
