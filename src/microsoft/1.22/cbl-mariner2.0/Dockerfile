#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

FROM mcr.microsoft.com/cbl-mariner/base/core:2.0

ENV PATH /usr/local/go/bin:$PATH

ENV GOLANG_VERSION 1.22.2

RUN set -eux; \
	arch="$(uname -m)"; \
	url=; \
	case "$arch" in \
		'x86_64') \
			url='https://dotnetbuildoutput.blob.core.windows.net/golang/microsoft/release-branch.go1.22/20240403.7/go1.22.2-20240403.7.linux-amd64.tar.gz'; \
			sha256='f4780456c13e8e616ed4613515c9a462f45118cd5fd71a90eab5235aaa2428e0'; \
			;; \
		'armv7') \
			url='https://dotnetbuildoutput.blob.core.windows.net/golang/microsoft/release-branch.go1.22/20240403.7/go1.22.2-20240403.7.linux-armv6l.tar.gz'; \
			sha256='f3a2bb2da5c03e1a9043f85f57a5b5b696add2f5013e1120adffc211e12d9ee7'; \
			;; \
		'aarch64') \
			url='https://dotnetbuildoutput.blob.core.windows.net/golang/microsoft/release-branch.go1.22/20240403.7/go1.22.2-20240403.7.linux-arm64.tar.gz'; \
			sha256='a753b5a9db4e0fc88e12b3b6d8f8d27fd6bd15edf222f9e96314a338d7c6d55d'; \
			;; \
		*) echo >&2 "error: unsupported architecture '$arch' (likely packaging update needed)"; exit 1 ;; \
	esac; \
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
# save the timestamp from the tarball so we can restore it for reproducibility, if necessary (see below)
	SOURCE_DATE_EPOCH="$(stat -c '%Y' /usr/local/go)"; \
	export SOURCE_DATE_EPOCH; \
# for logging validation/edification
	date --date "@$SOURCE_DATE_EPOCH" --rfc-2822; \
	\
	if [ "$arch" = 'armv7' ]; then \
		[ -s /usr/local/go/go.env ]; \
		before="$(go env GOARM)"; [ "$before" != '7' ]; \
		{ \
			echo; \
			echo '# https://github.com/docker-library/golang/issues/494'; \
			echo 'GOARM=7'; \
		} >> /usr/local/go/go.env; \
		after="$(go env GOARM)"; [ "$after" = '7' ]; \
# (re-)clamp timestamp for reproducibility (allows "COPY --link" to be more clever/useful)
		date="$(date -d "@$SOURCE_DATE_EPOCH" '+%Y%m%d%H%M.%S')"; \
		touch -t "$date" /usr/local/go/go.env /usr/local/go; \
	fi; \
	\
# smoke test
	go version; \
# make sure our reproducibile timestamp is probably still correct (best-effort inline reproducibility test)
	epoch="$(stat -c '%Y' /usr/local/go)"; \
	[ "$SOURCE_DATE_EPOCH" = "$epoch" ]

FROM mcr.microsoft.com/cbl-mariner/base/core:2.0

RUN set -eux; \
# Upgrade all packages per https://eng.ms/docs/more/containers-secure-supply-chain/updating
	tdnf update -y; \
	tdnf install -y \
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


ENV GOLANG_VERSION 1.22.2

# don't auto-upgrade the gotoolchain
# https://github.com/docker-library/golang/issues/472
ENV GOTOOLCHAIN=local

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
COPY --from=build /usr/local/go/ /usr/local/go/
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 1777 "$GOPATH"
WORKDIR $GOPATH
