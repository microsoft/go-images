#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

FROM mcr.microsoft.com/mirror/docker/library/buildpack-deps:bookworm-scm AS build

# Refresh CA roots before fetching Microsoft-hosted Go artifacts.
RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends ca-certificates; \
	rm -rf /var/lib/apt/lists/*

ENV PATH /usr/local/go/bin:$PATH

ENV GOLANG_VERSION 1.26.7

RUN set -eux; \
	now="$(date '+%s')"; \
	arch="$(dpkg --print-architecture)"; arch="${arch##*-}"; \
	url=; \
	urlSig=; \
	case "$arch" in \
		'amd64') \
			url='https://download.visualstudio.microsoft.com/download/pr/41b3c5b3-4064-4059-b8ee-7ef7bd749531/2213a63f5db48361095a0100894e06c1/go1.26.7-20260819.2.linux-amd64.tar.gz'; \
			urlSig='https://download.visualstudio.microsoft.com/download/pr/41b3c5b3-4064-4059-b8ee-7ef7bd749531/e91846ed2267229796a554079fa1f8e5/go1.26.7-20260819.2.linux-amd64.tar.gz.sig'; \
			sha256='8c7c598971462ff2c7b304ee874a8939b68c52a36036c1fd55d1ed0404452711'; \
			;; \
		'armhf') \
			url='https://download.visualstudio.microsoft.com/download/pr/41b3c5b3-4064-4059-b8ee-7ef7bd749531/3cd1b2dc5269cdc1e573136c7cdcf6e7/go1.26.7-20260819.2.linux-armv6l.tar.gz'; \
			urlSig='https://download.visualstudio.microsoft.com/download/pr/41b3c5b3-4064-4059-b8ee-7ef7bd749531/20eed68104b87ea3efc9747a1227bca0/go1.26.7-20260819.2.linux-armv6l.tar.gz.sig'; \
			sha256='7e674ff53d8545dae31539d85072989fe108cf991702a622984ecf512476078b'; \
			;; \
		'arm64') \
			url='https://download.visualstudio.microsoft.com/download/pr/41b3c5b3-4064-4059-b8ee-7ef7bd749531/5f5e830f5817adb1ba1e27eb393c70c6/go1.26.7-20260819.2.linux-arm64.tar.gz'; \
			urlSig='https://download.visualstudio.microsoft.com/download/pr/41b3c5b3-4064-4059-b8ee-7ef7bd749531/cb9a715d023073bf8b00093dfa8879a7/go1.26.7-20260819.2.linux-arm64.tar.gz.sig'; \
			sha256='17f2001fa8d2ad1a73f68452f472f5aa66db483474a4eaeb34efcbc6f8c7c8c3'; \
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
# Vendor the Microsoft build of Go public key. See https://github.com/microsoft/go-lab/issues/423
	printf '%s\n' \
		'-----BEGIN PGP PUBLIC KEY BLOCK-----' \
		'Version: BSN Pgp v1.1.0.0' \
		'' \
		'mQENBGBt3ocBCAC0eCjRdhrHwMGh4pxw/JFulp+QcqymS9eYr7leZutRB9CpjW4O' \
		'lXUzHzr8nIKoTbgNiak5Ws80LYvoPHwUjKqVypeRqG1vHoWzwy1t5U6imtcCspLK' \
		'nbqkx2JFG6zcG5Dve4Kp1VeiJBQ+SwVaZfwEFFPDeCFqg2MptC7xIka2WqSTXZyL' \
		'3PY/hNKXVeBJEg/et31FLZxWVr4/AJszu+aqhNqVMsqM8ldQF4QwVmoJQjCS/+Uy' \
		'Nw8Dt/THbaFQvn5Tnio3Yjc+7wiKhcE1JQAi5Cj/lTFQHLGTCm21c1fJ5HTI+pTt' \
		'O+HwJg4Wj3DEn7o+5VXj5JBtPmDxU0U6cR3vABEBAAG0QE1hbmFnZWQgTGFuZ3Vh' \
		'Z2VzIENvbXBpbGVyIERldiBUZWFtIDxtbGFuZ2NvbXBkZXZAbWljcm9zb2Z0LmNv' \
		'bT6JATgEEwEIACIFAmBt3ocCGwMGCwkIBwMCBhUIAgkKCwQWAgMBAh4BAheAAAoJ' \
		'EIEQBTR7jnMsdlQH/1XJO01wECeC1AMIQhNJueb5hBv+7AfSeKF36uQuX9rx5Lxp' \
		'hBgb9x3iEK5CE+xDtLmXx2yJZJIUtLbqxXhAa0Ph1dyLXRKAbVgv3dPlsAzPusMu' \
		'GjTyGeHNAVwodyTp3pggxzWtjoBGnVxpCNpqVDlepzoyBAfP51dd0oQ2JBfaBpNP' \
		'ft04A69W8eS/6pwFvUL5g5zPvczsBJmqMmSiDrNKeSa68/2k9ey1DlbhfA3FPPUx' \
		'13xCFv9pwieHHSyunbTbLzPnfRVdSlA16W7WT9aeF46R4/QyHc4AeU1p8HJtlDPz' \
		'jy3zx0Vd4u+rvgekEhHI7zFyHIdwHWD3UoV9Flk=' \
		'=EZkZ' \
		'-----END PGP PUBLIC KEY BLOCK-----' \
		> microsoft-managed-lang-compiler.asc; \
	gpg --batch --show-keys --with-colons --with-fingerprint microsoft-managed-lang-compiler.asc \
		| grep -q '^fpr:::::::::B035FAC203AB9A45AAC802B4811005347B8E732C:$'; \
	gpg --batch --show-keys --with-colons --with-fingerprint microsoft-managed-lang-compiler.asc \
		| grep -q '^uid:.*:Managed Languages Compiler Dev Team <mlangcompdev@microsoft.com>:'; \
	gpg --batch --import microsoft-managed-lang-compiler.asc; \
	rm microsoft-managed-lang-compiler.asc; \
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

ENV GOLANG_VERSION 1.26.7

# don't auto-upgrade the gotoolchain
# https://github.com/docker-library/golang/issues/472
ENV GOTOOLCHAIN=local

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
# (see notes above about "COPY --link")
COPY --from=build /target/ /
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 1777 "$GOPATH"
WORKDIR $GOPATH
