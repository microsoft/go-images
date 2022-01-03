#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

FROM cblmariner.azurecr.io/base/core:1.0.20211027

RUN tdnf install -y \
		binutils \
		gcc \
		glibc \
		glibc-devel \
		kernel-headers \
		iana-etc \
		# Install OpenSSL for headers when building a FIPS-compatible app with Go.
		openssl-devel \
	; \
	tdnf clean all


ENV PATH /usr/local/go/bin:$PATH

ENV GOLANG_VERSION 1.17.5

RUN set -eux; \
	arch="$(uname -m)"; \
	url=; \
	case "$arch" in \
		'x86_64') \
			url='https://dotnetbuildoutput.blob.core.windows.net/golang/microsoft/dev/official/go1.17-openssl-fips/20220103.2/go.20220103.2.linux-amd64.tar.gz'; \
			sha256='d225909015a0341c7a2860f9665ded0e706bd3d769fd4b41aae3b320ef7cf026'; \
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
# NO MICROSOFT_UPSTREAM: Change ".asc" to ".sig" to match the filename we publish. https://github.com/microsoft/go/issues/181
	wget -O go.tgz.asc "$url.sig" --progress=dot:giga; \
# END NO MICROSOFT_UPSTREAM
	wget -O go.tgz "$url" --progress=dot:giga; \
	echo "$sha256 *go.tgz" | sha256sum -c -; \
	\
# https://github.com/golang/go/issues/14739#issuecomment-324767697
	GNUPGHOME="$(mktemp -d)"; export GNUPGHOME; \
# NO MICROSOFT_UPSTREAM: Grab the public key used for the Microsoft builds of Go. https://github.com/microsoft/go/issues/47
	wget -O microsoft-managed-lang-compiler.asc 'https://download.microsoft.com/download/f/a/2/fa2420dd-3f08-4621-82cf-5a22abcbc8f9/microsoft-managed-lang-compiler.asc'; \
	gpg --batch --import microsoft-managed-lang-compiler.asc; \
# END NO MICROSOFT_UPSTREAM
# https://www.google.com/linuxrepositories/
	gpg --batch --keyserver keyserver.ubuntu.com --recv-keys 'EB4C 1BFD 4F04 2F6D DDCC EC91 7721 F63B D38B 4796'; \
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
# pre-compile the standard library, just like the official binary release tarballs do
		go install std; \
# go install: -race is only supported on linux/amd64, linux/ppc64le, linux/arm64, freebsd/amd64, netbsd/amd64, darwin/amd64 and windows/amd64
#		go install -race std; \
		\
# remove a few intermediate / bootstrapping files the official binary release tarballs do not contain
		rm -rf \
			/usr/local/go/pkg/*/cmd \
			/usr/local/go/pkg/bootstrap \
			/usr/local/go/pkg/obj \
			/usr/local/go/pkg/tool/*/api \
			/usr/local/go/pkg/tool/*/go_bootstrap \
			/usr/local/go/src/cmd/dist/dist \
		; \
	fi; \
	\
	# We downloaded a FIPS/OpenSSL version of Go that may have been built with a different version
	# of OpenSSL than we have installed in this image. That makes them incompatible and Go will fail
	# to load OpenSSL. To fix this, recompile the boring/OpenSSL package on the current system. Also
	# recompile commands so "go run", "go build" and other commands work under FIPS mode.
	#
	# Note that in microsoft/go-images, we always download a prebuilt copy of Go, so we don't need
	# to worry about checking "$build" here to avoid unnecessary work.
	/usr/local/go/bin/go install -a crypto/internal/boring cmd; \
	\
	go version

ENV GOPATH /go
ENV PATH $GOPATH/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH
