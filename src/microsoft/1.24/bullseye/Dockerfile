#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

FROM mcr.microsoft.com/mirror/docker/library/buildpack-deps:bullseye-scm AS build

# Remove optional packages that are marked as vulnerable and that don't have fixes available.
# Then try to install up-to-date versions, so that if the distro makes them available in the future,
# our next build will automatically include them.
RUN set -eux; \
	apt-get autoremove -y \
		subversion \
	; \
	apt-get satisfy -y 'subversion (>= 1.14.5)' || echo 'patched subversion not available' ; \
	rm -rf /var/lib/apt/lists/*

ENV PATH /usr/local/go/bin:$PATH

ENV GOLANG_VERSION 1.24.5

RUN set -eux; \
	now="$(date '+%s')"; \
	arch="$(dpkg --print-architecture)"; arch="${arch##*-}"; \
	url=; \
	urlSig=; \
	case "$arch" in \
		'amd64') \
			url='https://download.visualstudio.microsoft.com/download/pr/4ba02eab-f12f-46f0-8d2e-561a36985ed3/efd09946006859e3eef6281d7e4365cf/go1.24.5-20250708.7.linux-amd64.tar.gz'; \
			urlSig='https://download.visualstudio.microsoft.com/download/pr/4ba02eab-f12f-46f0-8d2e-561a36985ed3/c5a72dfc33788f46257322382ebda643/go1.24.5-20250708.7.linux-amd64.tar.gz.sig'; \
			sha256='109829f011521e7fa68fe9eab62243265a22d1386a7495cbcab92359f000fe09'; \
			;; \
		'armhf') \
			url='https://download.visualstudio.microsoft.com/download/pr/4ba02eab-f12f-46f0-8d2e-561a36985ed3/46baf965f9b88d5bdd0c7809010805bf/go1.24.5-20250708.7.linux-armv6l.tar.gz'; \
			urlSig='https://download.visualstudio.microsoft.com/download/pr/4ba02eab-f12f-46f0-8d2e-561a36985ed3/b6b9f9bbe2fdbcd14365bb0485deb34f/go1.24.5-20250708.7.linux-armv6l.tar.gz.sig'; \
			sha256='a097eb6c197f85914082b77fcf2cdddc246c37c72e9beddd11cb4ed62a7a331a'; \
			;; \
		'arm64') \
			url='https://download.visualstudio.microsoft.com/download/pr/4ba02eab-f12f-46f0-8d2e-561a36985ed3/028f3a99498f240dff599068b0f21514/go1.24.5-20250708.7.linux-arm64.tar.gz'; \
			urlSig='https://download.visualstudio.microsoft.com/download/pr/4ba02eab-f12f-46f0-8d2e-561a36985ed3/6798306a4cf768f5f37b6c209afa97fa/go1.24.5-20250708.7.linux-arm64.tar.gz.sig'; \
			sha256='4fe69b51d1dde0442fd8cbae12559828d12236ca17c656d71eff7ff8adfdc82e'; \
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

ENV GOLANG_VERSION 1.24.5

# don't auto-upgrade the gotoolchain
# https://github.com/docker-library/golang/issues/472
ENV GOTOOLCHAIN=local

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
# (see notes above about "COPY --link")
COPY --from=build /target/ /
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 1777 "$GOPATH"
WORKDIR $GOPATH
