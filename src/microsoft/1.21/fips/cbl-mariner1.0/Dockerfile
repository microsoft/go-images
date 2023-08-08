#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

# This Dockerfile is based on our ordinary Dockerfile, but adds a layer that enables the
# systemcrypto GOEXPERIMENT, choosing a crypto backend that supports FIPS mode on the target platform.
#
# The ARG default values are here for anyone who builds this repository without the .NET Docker
# build tools. If they build the non-FIPS images with the obvious tags, this "from" should line up.
# The .NET Docker build infrastructure replaces the ARGs with arch-specific values, etc.
ARG REPO=mcr.microsoft.com/oss/go/microsoft/golang
ARG FROM_TAG=1.21.0-2-cbl-mariner1.0

FROM $REPO:$FROM_TAG

ENV GOEXPERIMENT systemcrypto
