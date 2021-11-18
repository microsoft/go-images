#!/usr/bin/env pwsh
param(
    # Version of Go to filter by.
    # This is '*' in upstream, but empty here to work around an issue when building on Linux: https://github.com/dotnet/dotnet-docker/issues/3288
    [string]$Version = "",

    # Name of OS to filter by
    [string]$OS,

    # Type of architecture to filter by
    [string]$Architecture,

    # Additional custom path filters
    [string[]]$Paths,

    # Additional args to pass to ImageBuilder
    [string]$OptionalImageBuilderArgs
)

# This script is copied from .NET Docker and modified to suit our usage. See the original script
# (https://github.com/dotnet/dotnet-docker/blob/main/build-and-test.ps1) when adding more
# functionality here. Follow the .NET Docker methodology when possible for consistency and
# compatibility with changes to the core .NET Docker shared infrastructure.

# Build the product images.
& $PSScriptRoot/common/build.ps1 `
    -Version $Version `
    -OS $OS `
    -Architecture $Architecture `
    -Paths $Paths `
    -OptionalImageBuilderArgs $OptionalImageBuilderArgs
