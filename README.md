# Docker images containing the Microsoft build of Go

This repository creates Docker images that contain the Microsoft build of Go
produced by the [microsoft/go](https://github.com/microsoft/go) repository. The
tags are published on the Microsoft Container Registry (MCR) in the
`oss/go/microsoft/golang` repository.

The submodule named `go` contains the source code for the official Golang image
repository, https://github.com/docker-library/golang. The submodule contains
templates that this repository uses to create the Dockerfiles that contain the
Microsoft build of Go.

See [eng/README.md](eng/README.md) for information about the infrastructure.

To view the list of available tags:

* Microsoft Container Registry API: https://mcr.microsoft.com/v2/oss/go/microsoft/golang/tags/list
  * The full tag URL is `mcr.microsoft.com/{name}:{tag}`
* AZCU Indexer (Microsoft auth required): https://azcuindexer.azurewebsites.net/repositories/oss/go/microsoft/golang
  * Click on a tag name to copy the full tag URL to your clipboard

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
