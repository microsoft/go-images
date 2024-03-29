#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

FROM mcr.microsoft.com/cbl-mariner/base/core:2.0

RUN tdnf install -y \
		binutils \
		gcc \
		glibc \
		glibc-devel \
		iana-etc \
		kernel-headers \
		tar \
		wget \
		# To reduce image size, CBL-Mariner image doesn't include full ca-certificates: https://github.com/microsoft/CBL-Mariner/issues/3563
		# Full certs are expected in a builder-style image (e.g. to fetch dependencies), so install them.
		ca-certificates \
	; \
	tdnf clean all


ENV PATH /usr/local/go/bin:$PATH

ENV GOLANG_VERSION 1.22.1

RUN set -eux; \
	arch="$(uname -m)"; \
	url=; \
	case "$arch" in \
		'x86_64') \
			url='https://dotnetbuildoutput.blob.core.windows.net/golang/microsoft/release-branch.go1.22/20240321.8/go1.22.1-20240321.8.linux-amd64.tar.gz'; \
			sha256='2928adebf5139a4ed9365145357b5d4cd72c4de68b773bea76a6013e27589229'; \
			;; \
		'armv7') \
			url='https://dotnetbuildoutput.blob.core.windows.net/golang/microsoft/release-branch.go1.22/20240321.8/go1.22.1-20240321.8.linux-armv6l.tar.gz'; \
			sha256='9ab24e136fcf71d32f9024be641f6bb4dc95f7e81ddd29a3134aa431d32aea42'; \
			;; \
		'aarch64') \
			url='https://dotnetbuildoutput.blob.core.windows.net/golang/microsoft/release-branch.go1.22/20240321.8/go1.22.1-20240321.8.linux-arm64.tar.gz'; \
			sha256='b74664c8d5466ca3c9e3ed460c773608b532bc623643e4916c5a8bc790084bd8'; \
			;; \
		*) echo >&2 "error: unsupported architecture '$arch' (likely packaging update needed)"; exit 1 ;; \
	esac; \
	build=; \
	if [ -z "$url" ]; then \
# https://github.com/golang/go/issues/38536#issuecomment-616897960
		build=1; \
		url=null; \
		sha256=null; \
		echo >&2; \
		echo >&2 "warning: current architecture ($arch) does not have a compatible Go binary release; will be building from source"; \
		echo >&2; \
	fi; \
	\
	wget -O go.tgz.asc "$url.sig"; \
	wget -O go.tgz "$url" --progress=dot:giga; \
	echo "$sha256 *go.tgz" | sha256sum -c -; \
	\
# https://github.com/golang/go/issues/14739#issuecomment-324767697
	GNUPGHOME="$(mktemp -d)"; export GNUPGHOME; \
	wget -O microsoft-managed-lang-compiler.asc 'https://download.microsoft.com/download/f/a/2/fa2420dd-3f08-4621-82cf-5a22abcbc8f9/microsoft-managed-lang-compiler.asc'; \
	gpg --batch --import microsoft-managed-lang-compiler.asc; \
# Mariner 2.0 doesn't include dirmngr, which is required for keyserver import. Skipping keyserver
# import. In microsoft/go-images, we use a manually imported key anyway.
# See https://github.com/microsoft/CBL-Mariner/issues/3142
	gpg --batch --verify go.tgz.asc go.tgz; \
	gpgconf --kill all; \
	rm -rf "$GNUPGHOME" go.tgz.asc; \
	\
	tar -C /usr/local -xzf go.tgz; \
	rm go.tgz; \
	\
	if [ -n "$build" ]; then \
		savedAptMark="$(apt-mark showmanual)"; \
		apt-get update; \
		apt-get install -y --no-install-recommends golang-go; \
		\
		export GOCACHE='/tmp/gocache'; \
		\
		( \
			cd /usr/local/go/src; \
# set GOROOT_BOOTSTRAP + GOHOST* such that we can build Go successfully
			export GOROOT_BOOTSTRAP="$(go env GOROOT)" GOHOSTOS="$GOOS" GOHOSTARCH="$GOARCH"; \
			./make.bash; \
		); \
		\
		apt-mark auto '.*' > /dev/null; \
		apt-mark manual $savedAptMark > /dev/null; \
		apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
		rm -rf /var/lib/apt/lists/*; \
		\
# remove a few intermediate / bootstrapping files the official binary release tarballs do not contain
		rm -rf \
			/usr/local/go/pkg/*/cmd \
			/usr/local/go/pkg/bootstrap \
			/usr/local/go/pkg/obj \
			/usr/local/go/pkg/tool/*/api \
			/usr/local/go/pkg/tool/*/go_bootstrap \
			/usr/local/go/src/cmd/dist/dist \
			"$GOCACHE" \
		; \
	fi; \
	\
	go version

ENV GOPATH /go
ENV PATH $GOPATH/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 1777 "$GOPATH"
WORKDIR $GOPATH
