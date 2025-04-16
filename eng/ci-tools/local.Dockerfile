# This Dockerfile produces an image that can be used locally (e.g. on Windows)
# to run the dockerupdate tool. It is not published to a registry and is
# intended for local use only. See README.md.

FROM mcr.microsoft.com/oss/go/microsoft/golang:cbl-mariner2.0

RUN set -eux; \
	tdnf update -y; \
	tdnf install -y \
		awk \
		git \
		jq \
	; \
	tdnf clean all

ADD . /go-images/eng/ci-tools

WORKDIR /go-images

RUN cd eng/ci-tools \
	&& go install github.com/microsoft/go-infra/cmd/dockerupdate \
	&& git config --global --add safe.directory /go-images \
	&& git config --global --add safe.directory /go-images/go

ENTRYPOINT ["/go/bin/dockerupdate"]
