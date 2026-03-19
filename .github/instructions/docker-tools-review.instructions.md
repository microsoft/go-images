---
description: "Use when reviewing pull requests that modify files in the eng/docker-tools/ directory. The eng/docker-tools/ directory is a direct copy of https://github.com/dotnet/docker-tools and must not be modified locally. Review should focus on compatibility of the rest of the repository with the upgraded docker-tools, not on the docker-tools files themselves."
applyTo: "eng/docker-tools/**"
---

# Docker-tools upgrade review

## Project context

The `eng/docker-tools/` directory is a **shared infrastructure layer** copied directly from [dotnet/docker-tools](https://github.com/dotnet/docker-tools). It provides PowerShell scripts, Azure Pipelines templates, and ImageBuilder orchestration used to build, test, and publish Docker images. Changes to these files originate upstream and are synchronized into this repository—they must not be modified locally.

## Rules to check

### Do not suggest changes to eng/docker-tools/ files

Files under `eng/docker-tools/` are owned by the upstream [dotnet/docker-tools](https://github.com/dotnet/docker-tools) repository. During PR review:

- **Do not** suggest code quality improvements, refactors, or bug fixes to any file under `eng/docker-tools/`
- **Do not** flag style, naming, or convention issues in `eng/docker-tools/` files
- **Do not** recommend adding or removing functionality in `eng/docker-tools/` files
- If a genuine bug is found in docker-tools, note that it should be fixed upstream in the dotnet/docker-tools repository, not in this repo

### Scan the rest of the repo for compatibility

When `eng/docker-tools/` files change (e.g. an upgrade to a newer version), review the **rest of the repository** to determine whether additional changes are needed to remain compatible. Key areas to check:

- **Pipeline files** (`eng/pipeline/**`): Verify that template references (`/eng/docker-tools/templates/...`) still resolve correctly. Check for renamed, removed, or restructured templates. Confirm that parameter names and values passed to docker-tools templates are still valid
- **Pipeline variables** (`eng/pipeline/variables/**`): Ensure variable names expected by docker-tools templates are still defined and match any new or renamed expectations
- **Manifest file** (`manifest.json`): Confirm the manifest schema is compatible with the version of ImageBuilder used by the upgraded docker-tools
- **Build scripts** (`eng/build.ps1`, any local PowerShell scripts): Check for calls to docker-tools scripts that may have changed signatures or behavior
- **Dockerfiles** (`go/**`, `src/microsoft/**`): If docker-tools changes affect Dockerfile conventions (e.g. stage naming, label requirements, SBOM generation), verify Dockerfiles conform

### Check for breaking parameter changes

Compare the parameters sections of changed docker-tools templates against how they are invoked in `eng/pipeline/` files. Flag any case where:

- A required parameter was added upstream but is not supplied by the calling pipeline
- A parameter was renamed or removed upstream but the old name is still used in the calling pipeline
- Default values changed in a way that could alter build behavior

### Check for new variable requirements

If docker-tools templates introduce new variable references (e.g. `$(newVariable)`), verify that those variables are defined in:

- `eng/pipeline/variables/common.yml`
- `eng/pipeline/variables/go-common.yml`
- `eng/pipeline/variables/pipeline.yml`
- Or any other variable file included in the pipeline

## How to review

1. **Identify the docker-tools changes**: Note which files under `eng/docker-tools/` were added, modified, or removed
2. **Do not review docker-tools content**: Skip code review of the docker-tools files themselves—they are upstream-owned
3. **Scan pipeline references**: Search `eng/pipeline/` for all references to `/eng/docker-tools/` templates and verify they are still valid
4. **Check variable definitions**: Cross-reference any new or changed variables in docker-tools templates against the repo's variable files
5. **Verify companion changes**: If the PR includes changes outside `eng/docker-tools/`, review those changes for correctness and compatibility
6. **Flag missing updates**: If docker-tools changes require corresponding updates elsewhere in the repo that are not included in the PR, flag them specifically
7. **If no issues**: Include the message "Docker-tools upgrade looks compatible!" in the review conclusion if no compatibility issues are found

## Review tone

- Do not critique the docker-tools code itself—it is upstream-owned
- Focus on whether the rest of the repository is compatible with the new docker-tools version
- Be specific about which pipeline files, variables, or templates need updates
- Frame suggestions as compatibility requirements, not style preferences
