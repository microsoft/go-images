#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

# This Dockerfile is based on our non-FIPS Dockerfile, but then adds a layer that enables the
# OpenSSL-backed FIPS mode by default.
#
# The ARG default values are here for anyone who builds this repository without the .NET Docker
# build tools. If they build the non-FIPS images with the obvious tags, this "from" should line up.
# The .NET Docker build infrastructure replaces the ARGs with arch-specific values, etc.
ARG REPO=mcr.microsoft.com/oss/go/microsoft/golang
ARG FROM_TAG=1.20.2-1-buster

FROM $REPO:$FROM_TAG

ENV GOEXPERIMENT opensslcrypto
