FROM debian:latest

RUN apt update && \
    apt upgrade -y && \
    apt install -y \
        apt-transport-https \
        apt-utils \
        bzip2 \
        ca-certificates \
        cmake \
        curl \
        dialog \
        dirmngr \
        git-lfs \
        git \
        gnupg2 \
        htop \
        init-system-helpers \
        iproute2 \
        jq \
        less \
        libc6 \
        libgcc1 \
        libgssapi-krb5-2 \
        libkrb5-3 \
        libstdc++6 \
        locales \
        lsb-release \
        lsof \
        man-db \
        manpages-dev \
        manpages \
        nano \
        ncdu \
        net-tools \
        ninja-build \
        openssh-client \
        procps \
        psmisc \
        rsync \
        strace \
        sudo \
        tree \
        unzip \
        vim-tiny \
        wget \
        xz-utils \
        zip \
        zlib1g && \
    wget "https://github.com/PowerShell/PowerShell/releases/download/v7.4.1/powershell_7.4.1-1.deb_amd64.deb" -O powershell.deb && \
    dpkg -i powershell.deb && \
    rm powershell.deb && \
    apt update && \
    apt install powershell

RUN wget "https://github.com/QuestPackageManager/ndk-canary-archive/releases/download/27.0.1/android-ndk-10883340-linux-x86_64.zip" -O "ndk.zip" && \
    unzip -o "ndk.zip" -d "/" && \
    rm "ndk.zip"

RUN wget "https://github.com/QuestPackageManager/QPM.CLI/releases/latest/download/qpm-linux-x64.zip" -O "qpm.zip" && \
    unzip -o "qpm.zip" -d /usr/bin && \
    chmod +rx /usr/bin/qpm && \
    rm "qpm.zip"

RUN LATEST_RELEASE="$(curl -s https://api.github.com/repos/clangd/clangd/releases/latest | jq -r '.assets[] | select(.name | contains("clangd-linux")) | .browser_download_url')" && \
    wget "$LATEST_RELEASE" -O "clangd.zip" && \
    mkdir -p /clangd && \
    unzip -o "clangd.zip" -d /clangd && \
    rm "clangd.zip" && \
    chmod -R +rx && /clangd \
    mv /clangd/*/* /clangd && \
    rmdir /clangd/* || true

ENV PATH="$PATH:/clangd/bin"
ENV ANDROID_NDK_HOME=/android-ndk-r27-canary


