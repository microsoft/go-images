# Docker images containing the Microsoft build of Go

This repository creates Docker images that contain the Microsoft build of Go produced by the [microsoft/go](https://github.com/microsoft/go) repository. The tags are published on the Microsoft Container Registry (MCR) in the `oss/go/microsoft/golang` repository.

In general, the microsoft/go-images tag names match those available for the [Docker Hub golang official image](https://hub.docker.com/_/golang). To switch from the official image to one on MCR, it may be possible to simply prepend `mcr.microsoft.com/oss/go/microsoft/` to the official image you would normally use.

This tag is recommended for general build scenarios:

```
mcr.microsoft.com/oss/go/microsoft/golang:1.17-bullseye
```

If you need to build a FIPS-compatible app, use a `fips` tag, such as:

```
mcr.microsoft.com/oss/go/microsoft/golang:1.17-fips-cbl-mariner1.0
```

For more information about building FIPS-compatible Go apps with the Microsoft Go tools, visit [the FIPS readme](https://github.com/microsoft/go/tree/microsoft/dev.boringcrypto.go1.17/eng/doc/fips) and [user guide](https://github.com/microsoft/go/blob/microsoft/dev.boringcrypto.go1.17/eng/doc/fips/UserGuide.md) in the microsoft/go repository.

To view the full list of available Go tags in MCR:

* Use the [Microsoft Container Registry API](https://mcr.microsoft.com/v2/oss/go/microsoft/golang/tags/list)
  * The full tag URL is `mcr.microsoft.com/{name}:{tag}`
* Visit the [AZCU Indexer](https://azcuindexer.azurewebsites.net/repositories/oss/go/microsoft/golang) (*Microsoft internal auth required*)
  * Click on a tag name to copy the full tag URL to your clipboard

See [Tags of microsoft/go-images](docs/tags.md) for more information about tag names and support.

## Is this repository a fork?

We think it's accurate to call this repository a fork of the official Golang image repository, [docker-library/golang](https://github.com/docker-library/golang). See [microsoft/go#is-this-repository-a-fork](https://github.com/microsoft/go#is-this-repository-a-fork) for more details why.

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
