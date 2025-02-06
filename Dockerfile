FROM ubuntu:latest

RUN apt update && \
    apt upgrade -y && \
    apt install -y \
        apt-transport-https \
        apt-utils \
        bzip2 \
        ca-certificates \
        clangd \
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

RUN wget "https://github.com/QuestPackageManager/QPM.CLI/releases/latest/download/qpm-linux-x64.zip" -O "qpm.zip" && \
    unzip -o "qpm.zip" -d /usr/bin && \
    chmod +rx /usr/bin/qpm && \
    rm "qpm.zip"

ENV ANDROID_NDK_HOME=/android-ndk-r27-canary


