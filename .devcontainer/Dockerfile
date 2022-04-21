# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.231.3/containers/ubuntu/.devcontainer/base.Dockerfile

# [Choice] Ubuntu version (use hirsuite or bionic on local arm64/Apple Silicon): hirsute, focal, bionic
ARG VARIANT="hirsute"
# Base image from Microsoft vscode devcontainers (ubuntu)
FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}

# Capture our arguments for BYOND Major and Minor versions required (passed in from devcontainer.json)
ARG BYOND_MAJOR
ARG BYOND_MINOR
# Rust G Version to download/compile
ARG RUST_G_VERSION

# Add i386 arch (32 bit), update, upgrade, and install ca-certificates if not already
RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get dist-upgrade -y \
    && apt-get install -y --no-install-recommends \
    ca-certificates

# Dependencies for building byond for linux
RUN apt-get install -y --no-install-recommends \
    curl \
    unzip \
    make \
    libstdc++6:i386

# Set work directory
WORKDIR /tmp
# Download byond linux zip, unzip file, execute `make`, update resulting file permissions, remove dependencies used for compilation
RUN curl "https://www.byond.com/download/build/${BYOND_MAJOR}/${BYOND_MAJOR}.${BYOND_MINOR}_byond_linux.zip" -o byond.zip \
    && unzip byond.zip \
    && rm byond.zip \
    && cd byond \
    && sed -i 's|install:|&\n\tmkdir -p $(MAN_DIR)/man6|' Makefile \
    && make install \
    && chmod 644 /usr/local/byond/man/man6/* \
    && apt-get purge -y --auto-remove curl unzip make

# Install dependencies required to use our previously compiled rust_g
RUN apt-get install -y --no-install-recommends \
    libssl-dev:i386 \
    zlib1g-dev:i386

# Space Merge Requirements
RUN apt-get install -y --no-install-recommends \
    python \
    pip

# Space Merge Requirements cont.
RUN pip install GitPython

# Set work directory
WORKDIR /opt/rust_g
# Download the required `librust_g.so` from github releases
RUN wget -nv -O ./librust_g.so "https://github.com/tgstation/rust-g/releases/download/$RUST_G_VERSION/librust_g.so"
# Allow execution of the file
RUN chmod +x ./librust_g.so
