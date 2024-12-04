#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

FROM mcr.microsoft.com/mirror/docker/library/buildpack-deps:bullseye-scm AS build

ENV PATH /usr/local/go/bin:$PATH

ENV GOLANG_VERSION 1.22.10

RUN set -eux; \
	now="$(date '+%s')"; \
	arch="$(dpkg --print-architecture)"; arch="${arch##*-}"; \
	url=; \
	urlSig=; \
	case "$arch" in \
		'amd64') \
			url='https://download.visualstudio.microsoft.com/download/pr/549b0e83-52e7-4b33-bb9f-69335b7c670a/0ca83fa95ffb1500238afa2ff0a026e7/go1.22.10-20241203.4.linux-amd64.tar.gz'; \
			urlSig='https://download.visualstudio.microsoft.com/download/pr/549b0e83-52e7-4b33-bb9f-69335b7c670a/b5b7bff5b2e098f8b4128f9a9a0645bb/go1.22.10-20241203.4.linux-amd64.tar.gz.sig'; \
			sha256='4cee97a45df75e231d8bf04ab80547920b0bd830ed5adfbc01b525c83354cc87'; \
			;; \
		'armhf') \
			url='https://download.visualstudio.microsoft.com/download/pr/549b0e83-52e7-4b33-bb9f-69335b7c670a/d8355b08b6d34b3b0f09383d6b9c36dd/go1.22.10-20241203.4.linux-armv6l.tar.gz'; \
			urlSig='https://download.visualstudio.microsoft.com/download/pr/549b0e83-52e7-4b33-bb9f-69335b7c670a/ab1e9f11c54c4a9a7a2ea40c83de5c6a/go1.22.10-20241203.4.linux-armv6l.tar.gz.sig'; \
			sha256='704a3388458b9a35f878620c9d0b76b7433428eead41f6ee0e6bcb6994c28dbb'; \
			;; \
		'arm64') \
			url='https://download.visualstudio.microsoft.com/download/pr/549b0e83-52e7-4b33-bb9f-69335b7c670a/4ecb0268aed2bf966a3592c24a745cf4/go1.22.10-20241203.4.linux-arm64.tar.gz'; \
			urlSig='https://download.visualstudio.microsoft.com/download/pr/549b0e83-52e7-4b33-bb9f-69335b7c670a/dba89d6f050bbca5de48bdc71241d1b6/go1.22.10-20241203.4.linux-arm64.tar.gz.sig'; \
			sha256='44016e44de306663054762782d332a8796285593f437981a8e612bb27be15910'; \
			;; \
		*) echo >&2 "error: unsupported architecture '$arch' (likely packaging update needed)"; exit 1 ;; \
	esac; \
	\
	wget -O go.tgz.asc "$urlSig"; \
	wget -O go.tgz "$url" --progress=dot:giga; \
	echo "$sha256 *go.tgz" | sha256sum -c -; \
	\
# https://github.com/golang/go/issues/14739#issuecomment-324767697
	GNUPGHOME="$(mktemp -d)"; export GNUPGHOME; \
	wget -O microsoft-managed-lang-compiler.asc 'https://download.microsoft.com/download/f/a/2/fa2420dd-3f08-4621-82cf-5a22abcbc8f9/microsoft-managed-lang-compiler.asc'; \
	gpg --batch --import microsoft-managed-lang-compiler.asc; \
# https://www.google.com/linuxrepositories/
	gpg --batch --keyserver keyserver.ubuntu.com --recv-keys 'EB4C 1BFD 4F04 2F6D DDCC  EC91 7721 F63B D38B 4796'; \
# let's also fetch the specific subkey of that key explicitly that we expect "go.tgz.asc" to be signed by, just to make sure we definitely have it
	gpg --batch --keyserver keyserver.ubuntu.com --recv-keys '2F52 8D36 D67B 69ED F998  D857 78BD 6547 3CB3 BD13'; \
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
	touchy="$(date -d "@$SOURCE_DATE_EPOCH" '+%Y%m%d%H%M.%S')"; \
# for logging validation/edification
	date --date "@$SOURCE_DATE_EPOCH" --rfc-2822; \
# sanity check (detected value should be older than our wall clock)
	[ "$SOURCE_DATE_EPOCH" -lt "$now" ]; \
	\
	if [ "$arch" = 'armhf' ]; then \
		[ -s /usr/local/go/go.env ]; \
		before="$(go env GOARM)"; [ "$before" != '7' ]; \
		{ \
			echo; \
			echo '# https://github.com/docker-library/golang/issues/494'; \
			echo 'GOARM=7'; \
		} >> /usr/local/go/go.env; \
		after="$(go env GOARM)"; [ "$after" = '7' ]; \
# (re-)clamp timestamp for reproducibility (allows "COPY --link" to be more clever/useful)
		touch -t "$touchy" /usr/local/go/go.env /usr/local/go; \
	fi; \
	\
# ideally at this point, we would just "COPY --link ... /usr/local/go/ /usr/local/go/" but BuildKit insists on creating the parent directories (perhaps related to https://github.com/opencontainers/image-spec/pull/970), and does so with unreproducible timestamps, so we instead create a whole new "directory tree" that we can "COPY --link" to accomplish what we want
	mkdir /target /target/usr /target/usr/local; \
	mv -vT /usr/local/go /target/usr/local/go; \
	ln -svfT /target/usr/local/go /usr/local/go; \
	touch -t "$touchy" /target/usr/local /target/usr /target; \
	\
# smoke test
	go version; \
# make sure our reproducibile timestamp is probably still correct (best-effort inline reproducibility test)
	epoch="$(stat -c '%Y' /target/usr/local/go)"; \
	[ "$SOURCE_DATE_EPOCH" = "$epoch" ]

FROM mcr.microsoft.com/mirror/docker/library/buildpack-deps:bullseye-scm

# install cgo-related dependencies
RUN set -eux; \
	apt-get update; \
# Upgrade all packages per https://eng.ms/docs/more/containers-secure-supply-chain/updating
	apt-get upgrade -y; \
	apt-get install -y --no-install-recommends \
		g++ \
		gcc \
		libc6-dev \
		make \
		pkg-config \
	; \
	rm -rf /var/lib/apt/lists/*

ENV GOLANG_VERSION 1.22.10

# don't auto-upgrade the gotoolchain
# https://github.com/docker-library/golang/issues/472
ENV GOTOOLCHAIN=local

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
# (see notes above about "COPY --link")
COPY --from=build /target/ /
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 1777 "$GOPATH"
WORKDIR $GOPATH
