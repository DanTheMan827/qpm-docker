FROM debian:latest

RUN apt update && \
    apt install -y unzip wget cmake powershell ninja-build git git-lfs && \
    wget "https://github.com/PowerShell/PowerShell/releases/download/v7.4.1/powershell_7.4.1-1.deb_amd64.deb" -O powershell.deb && \
    dpkg -i powershell.deb && \
    rm powershell.deb

RUN wget "https://github.com/QuestPackageManager/ndk-canary-archive/releases/download/27.0.1/android-ndk-10883340-linux-x86_64.zip" -O "ndk.zip" && \
    unzip -o "ndk.zip" -d "/" && \
    rm "ndk.zip"

RUN wget "https://github.com/QuestPackageManager/QPM.CLI/releases/download/v1.1.0/qpm-linux-x64.zip" -O "qpm.zip" && \
    unzip -o "qpm.zip" -d /usr/bin && \
    chmod +rx /usr/bin/qpm && \
    rm "qpm.zip"

ENV ANDROID_NDK_HOME=/android-ndk-r27-canary
