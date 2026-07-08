# ci-tools

This module exists to store CI dependencies. Using a module dependency lets CI download/install the tool while verifying against the checked-in go.sum file.

This directory contains `local.Dockerfile`, which creates an image with `dockerupdate` installed.
See [eng/README.md#windows](../README.md#windows) for instructions on using it.

This module also contains the code generator for the Azure DevOps build pipelines.
Use `go generate .` in this directory to regenerate the pipelines.
