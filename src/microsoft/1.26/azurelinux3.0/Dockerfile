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

ENV GOLANG_VERSION 1.26.4

RUN set -eux; \
	now="$(date '+%s')"; \
	arch="$(uname -m)"; \
	url=; \
	urlSig=; \
	case "$arch" in \
		'x86_64') \
			url='https://download.visualstudio.microsoft.com/download/pr/88c9f950-d0f1-46ac-90d0-8e8b4095e743/30d6f3c908b93744d77f0cfcc29a8d0b/go1.26.4-20260602.8.linux-amd64.tar.gz'; \
			urlSig='https://download.visualstudio.microsoft.com/download/pr/88c9f950-d0f1-46ac-90d0-8e8b4095e743/01d9cf084a7b44851a25e5e34604b482/go1.26.4-20260602.8.linux-amd64.tar.gz.sig'; \
			sha256='fe7d72e1e83e15633d0a99bd67ce5ffbb67d8a5f71dcea309ff274457ef3c927'; \
			;; \
		'armv7') \
			url='https://download.visualstudio.microsoft.com/download/pr/88c9f950-d0f1-46ac-90d0-8e8b4095e743/0661020e65a0ca7812a1c63367eed92b/go1.26.4-20260602.8.linux-armv6l.tar.gz'; \
			urlSig='https://download.visualstudio.microsoft.com/download/pr/88c9f950-d0f1-46ac-90d0-8e8b4095e743/9c843b7a90372466a86f499c90d2b247/go1.26.4-20260602.8.linux-armv6l.tar.gz.sig'; \
			sha256='594e5c8c552ea19ac232ca124147f926296b36b7cb916ab21b3cf56ef6d724e7'; \
			;; \
		'aarch64') \
			url='https://download.visualstudio.microsoft.com/download/pr/88c9f950-d0f1-46ac-90d0-8e8b4095e743/4c37d72249bf2963ca1588c288cb547b/go1.26.4-20260602.8.linux-arm64.tar.gz'; \
			urlSig='https://download.visualstudio.microsoft.com/download/pr/88c9f950-d0f1-46ac-90d0-8e8b4095e743/9a41164a7097bd078dd112e2c7f02163/go1.26.4-20260602.8.linux-arm64.tar.gz.sig'; \
			sha256='9c1c8660dd3cec69415c476232ffb32d529e158d2b2deca4038804f1766f2f78'; \
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
# Vendor the Microsoft build of Go signature. See https://github.com/microsoft/go-lab/issues/423
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
	gpg --batch --show-keys --with-colons microsoft-managed-lang-compiler.asc \
		| grep -q '^fpr:::::::::B035FAC203AB9A45AAC802B4811005347B8E732C:$'; \
	gpg --batch --show-keys --with-colons microsoft-managed-lang-compiler.asc \
		| grep -q '^uid:.*:Managed Languages Compiler Dev Team <mlangcompdev@microsoft.com>:'; \
	gpg --batch --import microsoft-managed-lang-compiler.asc; \
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


ENV GOLANG_VERSION 1.26.4

# don't auto-upgrade the gotoolchain
# https://github.com/docker-library/golang/issues/472
ENV GOTOOLCHAIN=local

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
# (see notes above about "COPY --link")
COPY --from=build /target/ /
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 1777 "$GOPATH"
WORKDIR $GOPATH
