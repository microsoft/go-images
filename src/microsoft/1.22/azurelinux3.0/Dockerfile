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

ENV GOLANG_VERSION 1.22.7

RUN set -eux; \
	now="$(date '+%s')"; \
	arch="$(uname -m)"; \
	url=; \
	urlSig=; \
	case "$arch" in \
		'x86_64') \
			url='https://download.visualstudio.microsoft.com/download/pr/9d1d80df-e337-462a-a79b-6cb1272f437b/bb8d680f4146e18aa09b4c26784c70c2/go1.22.7-20240925.5.linux-amd64.tar.gz'; \
			urlSig='https://download.visualstudio.microsoft.com/download/pr/9d1d80df-e337-462a-a79b-6cb1272f437b/2fdc82ca000bc83dd76d8a085ca4d2e2/go1.22.7-20240925.5.linux-amd64.tar.gz.sig'; \
			sha256='c3a53478b4448e4c967384cd4bc343887a0fc3bb6022aac13c5045f23cdb5b1a'; \
			;; \
		'armv7') \
			url='https://download.visualstudio.microsoft.com/download/pr/9d1d80df-e337-462a-a79b-6cb1272f437b/d345f4d4499c2380e1dd2d4025aa6938/go1.22.7-20240925.5.linux-armv6l.tar.gz'; \
			urlSig='https://download.visualstudio.microsoft.com/download/pr/9d1d80df-e337-462a-a79b-6cb1272f437b/8ce160e23ca1596f4b8c3272c8622d5a/go1.22.7-20240925.5.linux-armv6l.tar.gz.sig'; \
			sha256='d7b3c53fbf709c463329e17aa4c6ba980f02b59c002cea9f9cdb04519aaccaa7'; \
			;; \
		'aarch64') \
			url='https://download.visualstudio.microsoft.com/download/pr/9d1d80df-e337-462a-a79b-6cb1272f437b/e4c24b3ec392111f7d934cbed555d9e7/go1.22.7-20240925.5.linux-arm64.tar.gz'; \
			urlSig='https://download.visualstudio.microsoft.com/download/pr/9d1d80df-e337-462a-a79b-6cb1272f437b/4f53d1b07d32cd6e4b9f16b6cee8d150/go1.22.7-20240925.5.linux-arm64.tar.gz.sig'; \
			sha256='974768cbde7de2587435e22f306604482ed8583f4677cd04cef87bf013febbbe'; \
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
	wget -O microsoft-managed-lang-compiler.asc 'https://download.microsoft.com/download/f/a/2/fa2420dd-3f08-4621-82cf-5a22abcbc8f9/microsoft-managed-lang-compiler.asc'; \
	gpg --batch --import microsoft-managed-lang-compiler.asc; \
# Azure Linux doesn't include dirmngr, which is required for keyserver import. Skipping keyserver
# import. In microsoft/go-images, we use a manually imported key anyway.
# See https://github.com/microsoft/azurelinux/issues/3142
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
		shadow-utils \
		util-linux \
	; \
	tdnf clean all


ENV GOLANG_VERSION 1.22.7

# don't auto-upgrade the gotoolchain
# https://github.com/docker-library/golang/issues/472
ENV GOTOOLCHAIN=local

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
# (see notes above about "COPY --link")
COPY --from=build /target/ /
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 1777 "$GOPATH"
WORKDIR $GOPATH
