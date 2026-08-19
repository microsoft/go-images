#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

FROM mcr.microsoft.com/azurelinux/base/core:3.0 AS build

# Dependencies needed to get the Go tarball. We never build Go from source in this Dockerfile.
RUN set -eux; \
# Upgrade all packages per https://eng.ms/docs/more/containers-secure-supply-chain/updating
	tdnf update -y; \
	tdnf install -y \
		tar \
		wget \
		# To reduce image size, the Azure Linux (aka CBL-Mariner) image doesn't include full ca-certificates: https://github.com/microsoft/azurelinux/issues/3563
		# We need ca-certificates here to verify https://download.visualstudio.microsoft.com.
		ca-certificates \
	; \
	tdnf clean all

ENV PATH /usr/local/go/bin:$PATH

ENV GOLANG_VERSION 1.25.14

RUN set -eux; \
	now="$(date '+%s')"; \
	arch="$(uname -m)"; \
	url=; \
	urlSig=; \
	case "$arch" in \
		'x86_64') \
			url='https://download.visualstudio.microsoft.com/download/pr/45c9587d-44d5-49d5-93bb-7523b6a10fa1/d6b8a06a6ed07b16914e0af653478360/go1.25.14-20260819.1.linux-amd64.tar.gz'; \
			urlSig='https://download.visualstudio.microsoft.com/download/pr/45c9587d-44d5-49d5-93bb-7523b6a10fa1/3e5ec0f916c49459cb875b1ce2b3842c/go1.25.14-20260819.1.linux-amd64.tar.gz.sig'; \
			sha256='25e61684d45ee160b0a9f92b567ec8a2ba96859ccb00b186aa1fba89c5f25ed4'; \
			;; \
		'armv7') \
			url='https://download.visualstudio.microsoft.com/download/pr/45c9587d-44d5-49d5-93bb-7523b6a10fa1/0f5e5ce4918ba024e193f22aaa7f14d1/go1.25.14-20260819.1.linux-armv6l.tar.gz'; \
			urlSig='https://download.visualstudio.microsoft.com/download/pr/45c9587d-44d5-49d5-93bb-7523b6a10fa1/dcb6bf7497f5a9de1e35c618da5359ca/go1.25.14-20260819.1.linux-armv6l.tar.gz.sig'; \
			sha256='9e2e6cac3705f329d572b33e630d95599b31d53d94f864dc5eeac5cb12f992db'; \
			;; \
		'aarch64') \
			url='https://download.visualstudio.microsoft.com/download/pr/45c9587d-44d5-49d5-93bb-7523b6a10fa1/bb0e2ec09ee38bad654400b1740bc7c3/go1.25.14-20260819.1.linux-arm64.tar.gz'; \
			urlSig='https://download.visualstudio.microsoft.com/download/pr/45c9587d-44d5-49d5-93bb-7523b6a10fa1/49a92afc72d3f565da55c9b7c0f8c707/go1.25.14-20260819.1.linux-arm64.tar.gz.sig'; \
			sha256='3e97236ea70c2b8743de9d3e68c554d9d642d4ad9ed44f5e1d27d5504d86ad62'; \
			;; \
		*) echo >&2 "error: unsupported architecture '$arch' (likely packaging update needed)"; exit 1 ;; \
	esac; \
	\
	wget -O go.tgz.asc "$urlSig"; \
# GNU Wget2 used by Azure Linux 3.0 no longer supports "--progress=dot:giga" and errors out. https://github.com/rockdaboot/wget2/issues/317
# We don't use it for any Azure Linux version for simplicity. (It worked in Azure Linux 2.0.)
	wget -O go.tgz "$url"; \
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
# Azure Linux doesn't include dirmngr, which is required for keyserver import. Skipping keyserver
# import. In microsoft/go-images, we use a manually imported key anyway.
# See https://microsoft.visualstudio.com/OS/_workitems/edit/62225284
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

FROM mcr.microsoft.com/azurelinux/base/core:3.0

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
		\
		# To reduce image size, the Azure Linux (aka CBL-Mariner) image doesn't include full ca-certificates: https://github.com/microsoft/azurelinux/issues/3563
		# Full certs are expected in a builder-style image (e.g., to fetch dependencies), so we need to install them.
		ca-certificates \
		\
		# Each of the following packages need to be installed for one or both of these reasons:
		# - Azure Pipelines specifies it as a requirement to use an image in container jobs: https://learn.microsoft.com/en-us/azure/devops/pipelines/process/container-phases?view=azure-devops
		# - The package is included in the Debian-based golang image, so installing it here improves compatibility.
		#
		# These packages don't need to be installed in a Debian golang Dockerfile because they are included by default in its base image: https://hub.docker.com/_/buildpack-deps/
		# The mcr.microsoft.com/cbl-mariner/base/core images are optimized for size to make them suitable for deployment, so many development tools aren't included.
		# There isn't a buildpack-deps analog for Azure Linux: https://github.com/microsoft/azurelinux/issues/8964 (https://devdiv.visualstudio.com/DevDiv/_workitems/edit/2055698)
		git \
		make \
		shadow-utils \
		util-linux \
		which \
	; \
	tdnf clean all


ENV GOLANG_VERSION 1.25.14

# don't auto-upgrade the gotoolchain
# https://github.com/docker-library/golang/issues/472
ENV GOTOOLCHAIN=local

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
# (see notes above about "COPY --link")
COPY --from=build /target/ /
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 1777 "$GOPATH"
WORKDIR $GOPATH
