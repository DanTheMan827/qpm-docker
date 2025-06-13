FROM alpine:latest AS qpm

RUN set -x && \
    apk add --no-cache \
        rustup  \
        openssl-dev \
        libssl3 \
        curl \
        git \
        build-base \
        jq

ENV OPENSSL_DIR=/usr
ENV OPENSSL_LIB_DIR=/usr/lib
ENV OPENSSL_INCLUDE_DIR=/usr/include
ENV OPENSSL_STATIC=0

RUN set -x && \
    rustup-init -y && \
    . "$HOME/.cargo/env" && \
    rustup default nightly && \
    rustup show

RUN set -x && \
    . "$HOME/.cargo/env" && \
    export OPENSSL_DIR=/usr && \
    export OPENSSL_LIB_DIR=/usr/lib && \
    export OPENSSL_INCLUDE_DIR=/usr/include && \
    export OPENSSL_STATIC=0 && \
    mkdir -p /qpm-temp && \
    cd /qpm-temp && \
    latest_tag=$(curl -s https://api.github.com/repos/QuestPackageManager/QPM.CLI/releases/latest | jq -r .tag_name) && \
    git clone --branch "$latest_tag" --single-branch https://github.com/QuestPackageManager/QPM.CLI.git . && \
    cargo build --release && \
    chmod +rx target/release/qpm

FROM alpine:latest

RUN set -x && \
    apk add --no-cache \
        bash \
        bzip2 \
        ca-certificates \
        cmake \
        curl \
        file \
        gcompat \
        git-lfs \
        git \
        htop \
        jq \
        less \
        libcrypto3 \
        libssl3 \
        lsof \
        man-db \
        nano \
        ninja-build \
        powershell \
        sudo \
        tree \
        unzip \
        vim \
        wget \
        xz \
        zip

RUN set -x && \
    LATEST_RELEASE="$(curl -s https://api.github.com/repos/clangd/clangd/releases/latest | jq -r '.assets[] | select(.name | contains("clangd-linux")) | .browser_download_url')" && \
    wget "$LATEST_RELEASE" -O "clangd.zip" && \
    mkdir -p /clangd && \
    unzip -o "clangd.zip" -d /clangd && \
    rm "clangd.zip" && \
    chmod -R +rx /clangd && \
    mv /clangd/*/* /clangd && \
    (rmdir /clangd/* || true) && \
    echo 'export PATH="$PATH:/clangd/bin"' >> /etc/profile
ENV PATH="$PATH:/clangd/bin"

COPY --from=qpm /qpm-temp/target/release/qpm /usr/bin/qpm

RUN set -x && \
    mkdir /ndk/ && \
    qpm config ndk-path /ndk/ && \
    qpm ndk download 27 && \
    chmod go+rwx /ndk && \
    echo "export ANDROID_NDK_HOME=\"$(ls -d /ndk/* | sort -r | head -n 1)\"" >> /etc/profile



ENTRYPOINT ["bash"]
