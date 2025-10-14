#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

FROM mcr.microsoft.com/mirror/docker/library/buildpack-deps:bullseye-scm AS build

ENV PATH /usr/local/go/bin:$PATH

ENV GOLANG_VERSION 1.24.9

RUN set -eux; \
	now="$(date '+%s')"; \
	arch="$(dpkg --print-architecture)"; arch="${arch##*-}"; \
	url=; \
	urlSig=; \
	case "$arch" in \
		'amd64') \
			url='https://download.visualstudio.microsoft.com/download/pr/060fa5c7-8cff-4ac0-b196-1c8f100e304c/1037667824cd76d4d3c281ad31ad91dd/go1.24.9-20251013.3.linux-amd64.tar.gz'; \
			urlSig='https://download.visualstudio.microsoft.com/download/pr/060fa5c7-8cff-4ac0-b196-1c8f100e304c/655e4c273efd5e199826c80b1d00790a/go1.24.9-20251013.3.linux-amd64.tar.gz.sig'; \
			sha256='1d54fded463be66d6ccfd95379de86f11fa9da7686ed3cfc05d59e87d9248f50'; \
			;; \
		'armhf') \
			url='https://download.visualstudio.microsoft.com/download/pr/060fa5c7-8cff-4ac0-b196-1c8f100e304c/0b7c8defc6d75acceb5546924c8c75f6/go1.24.9-20251013.3.linux-armv6l.tar.gz'; \
			urlSig='https://download.visualstudio.microsoft.com/download/pr/060fa5c7-8cff-4ac0-b196-1c8f100e304c/c357f5c3fbc8498306211baba4e1dc9a/go1.24.9-20251013.3.linux-armv6l.tar.gz.sig'; \
			sha256='182896278572b5e6ad5552cbc6c4dc9a4c6dddf99fed7955cb4dc65b41ed1bd5'; \
			;; \
		'arm64') \
			url='https://download.visualstudio.microsoft.com/download/pr/060fa5c7-8cff-4ac0-b196-1c8f100e304c/41f8798eeaa790ccc77a85d7e06796f3/go1.24.9-20251013.3.linux-arm64.tar.gz'; \
			urlSig='https://download.visualstudio.microsoft.com/download/pr/060fa5c7-8cff-4ac0-b196-1c8f100e304c/39c8e64a51cae367e128565850b85652/go1.24.9-20251013.3.linux-arm64.tar.gz.sig'; \
			sha256='62cbf3028a86e5fa75032c7ce6249cc002aa7ea70151789c9e25b34c64f4e329'; \
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

# Remove optional packages that are marked as vulnerable and that don't have fixes available.
# Then try to install up-to-date versions, so that if the distro makes them available in the future,
# our next build will automatically include them.
RUN set -eux; \
	apt-get autoremove -y \
		subversion \
	; \
	apt-get satisfy -y 'subversion (>= 1.14.5)' || echo 'patched subversion not available' ; \
	rm -rf /var/lib/apt/lists/*

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
# go depends on "gold" explicitly on arm64
# https://github.com/docker-library/golang/issues/570 (go depends on "gold" explicitly on arm64)
# https://github.com/golang/go/issues/22040
# ... and as of trixie, "gold" is removed from the "binutils" package:
# > WARNING: gold is being removed from binutils, and is deprecated upstream.
# (and available as "binutils-gold" which is also a virtual on bookworm so we can reasonably be explicit everywhere)
	dpkgArch="$(dpkg --print-architecture)"; \
	if [ "$dpkgArch" = 'arm64' ]; then \
		apt-get install -y --no-install-recommends binutils-gold; \
	fi; \
	rm -rf /var/lib/apt/lists/*

ENV GOLANG_VERSION 1.24.9

# don't auto-upgrade the gotoolchain
# https://github.com/docker-library/golang/issues/472
ENV GOTOOLCHAIN=local

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
# (see notes above about "COPY --link")
COPY --from=build /target/ /
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 1777 "$GOPATH"
WORKDIR $GOPATH
