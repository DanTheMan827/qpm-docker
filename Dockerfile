FROM ubuntu:latest

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
        libicu-dev \
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
        zlib1g

RUN LATEST_RELEASE="$(curl -s https://api.github.com/repos/PowerShell/PowerShell/releases/latest | jq -r '.assets[] | select(.name | contains("deb_amd64.deb")) | .browser_download_url')" && \
    wget "$LATEST_RELEASE" -O "powershell.deb" && \
    dpkg -i powershell.deb && \
    rm powershell.deb && \
    apt update && \
    apt install powershell

RUN LATEST_RELEASE="$(curl -s https://api.github.com/repos/clangd/clangd/releases/latest | jq -r '.assets[] | select(.name | contains("clangd-linux")) | .browser_download_url')" && \
    wget "$LATEST_RELEASE" -O "clangd.zip" && \
    mkdir -p /clangd && \
    unzip -o "clangd.zip" -d /clangd && \
    rm "clangd.zip" && \
    chmod -R +rx /clangd && \
    mv /clangd/*/* /clangd && \
    (rmdir /clangd/* || true)
ENV PATH="$PATH:/clangd/bin"

RUN wget "https://github.com/QuestPackageManager/QPM.CLI/releases/latest/download/qpm-linux-x64.zip" -O "qpm.zip" && \
    unzip -o "qpm.zip" -d /usr/bin && \
    chmod +rx /usr/bin/qpm && \
    rm "qpm.zip"

RUN mkdir /ndk/ && \
    qpm config ndk-path /ndk/ && \
    qpm ndk download 27 && \
    chmod go+rwx /ndk

RUN userdel -r ubuntu

# Set the ENTRYPOINT to bash with ANDROID_NDK_HOME set to the first folder in /ndk
ENTRYPOINT ["sh", "-c", "export ANDROID_NDK_HOME=\"$(ls -d /ndk/* | sort -r | head -n 1)\" && exec bash"]
