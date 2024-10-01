#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

FROM mcr.microsoft.com/mirror/docker/library/buildpack-deps:bookworm-scm AS build

ENV PATH /usr/local/go/bin:$PATH

ENV GOLANG_VERSION 1.22.8

RUN set -eux; \
	now="$(date '+%s')"; \
	arch="$(dpkg --print-architecture)"; arch="${arch##*-}"; \
	url=; \
	urlSig=; \
	case "$arch" in \
		'amd64') \
			url='https://download.visualstudio.microsoft.com/download/pr/5eb583bd-ddfb-4f9e-846f-fd78d9cccca2/3bad0f443f15b53c30ad07c755a403e8/go1.22.8-20241001.6.linux-amd64.tar.gz'; \
			urlSig='https://download.visualstudio.microsoft.com/download/pr/5eb583bd-ddfb-4f9e-846f-fd78d9cccca2/115c5fbddf0eed5c30c901501244483c/go1.22.8-20241001.6.linux-amd64.tar.gz.sig'; \
			sha256='f3f812fe9ce2e6f7ba14a38ad29b1e1907153bfb5589967086cb3ce367c13565'; \
			;; \
		'armhf') \
			url='https://download.visualstudio.microsoft.com/download/pr/5eb583bd-ddfb-4f9e-846f-fd78d9cccca2/789ea17076a107f2c1c2c6b715a1e8a0/go1.22.8-20241001.6.linux-armv6l.tar.gz'; \
			urlSig='https://download.visualstudio.microsoft.com/download/pr/5eb583bd-ddfb-4f9e-846f-fd78d9cccca2/7460059fca76cf6da510f9f88a41c03e/go1.22.8-20241001.6.linux-armv6l.tar.gz.sig'; \
			sha256='047c824a677a35e0e9ae57eb8bc9a76f0be4a507e0d465f2167bf96a1a7a104b'; \
			;; \
		'arm64') \
			url='https://download.visualstudio.microsoft.com/download/pr/5eb583bd-ddfb-4f9e-846f-fd78d9cccca2/c93c7c16f780ad2903f38724b4a4f454/go1.22.8-20241001.6.linux-arm64.tar.gz'; \
			urlSig='https://download.visualstudio.microsoft.com/download/pr/5eb583bd-ddfb-4f9e-846f-fd78d9cccca2/b00d47a617349b4e9791431d39d391ca/go1.22.8-20241001.6.linux-arm64.tar.gz.sig'; \
			sha256='9d77b18a2b1413ce41d925465d8132a982368a9d937252880d298cdb49978b3a'; \
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

FROM mcr.microsoft.com/mirror/docker/library/buildpack-deps:bookworm-scm

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

ENV GOLANG_VERSION 1.22.8

# don't auto-upgrade the gotoolchain
# https://github.com/docker-library/golang/issues/472
ENV GOTOOLCHAIN=local

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
# (see notes above about "COPY --link")
COPY --from=build /target/ /
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 1777 "$GOPATH"
WORKDIR $GOPATH
