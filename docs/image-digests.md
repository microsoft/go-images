# Image digests

See the [README's description of Docker image digests](/README.md#using-image-digests-to-pin-a-specific-image) for an overview of what image digests are and why you might want to use them.
This document describes how to find the digests and how to use them to roll back to a previous version of the Microsoft build of Go images.

## Current digests

To find the digest for the current Microsoft build of Go tag, use a command mentioned in the ["Image digests" documentation](https://docs.docker.com/dhi/core-concepts/digests/), or these direct commands, where `<tag>` is the tag you want to find the digest for:

```
docker pull mcr.microsoft.com/oss/go/microsoft/golang:<tag>
docker image inspect --format '{{index .RepoDigests 0}}' mcr.microsoft.com/oss/go/microsoft/golang:<tag>
```

Then, use the output in your Dockerfile, Azure Pipelines job, or elsewhere.
It should look like this:

```
mcr.microsoft.com/oss/go/microsoft/golang@sha256:<digest>
```

## Rolling back to a previous image version

If you encounter a problem with a new build of the Microsoft build of Go images, you can perform a rollback by pinning to a previous image digest.
The microsoft/go-images-versions [image-info JSON file][image-info] tracks the build output history using Git source control.

If you encounter a problem, [look for an existing open issue or contact us first](/SUPPORT.md).
We can provide the image digest to use to roll back to a working dependency.

The steps to roll back are:

1. Use the Git history of the [image-info JSON file][image-info] to find older versions of the containers.
    * Consider finding a commit timestamp before the problem started happening. Using a known good version helps confirm that the image is truly the root cause of the problem.
1. Look for the correct `productVersion` in the JSON.
1. Grab the `manifest` object's `digest` property value.
    * Use the manifest's digest rather than a specific platform's digest to ensure the digest has multi-architecture support.
1. Replace your reference to the tag with the `digest` property's value.
    * The value contains the full path, including repository, ready to use in any context that the tag was used.
1. Verify that the replacement pulls the expected platform-specific image and fixes the problem.
    1. If not, repeat these steps with a different version.

[image-info]: https://github.com/microsoft/go-images-versions/blob/main/go-images/image-info.microsoft-go-images-main.json
