FROM ubuntu:22.04

RUN apt-get update && \
    apt-get -y install wget gnupg2 xz-utils && \
    mkdir -p /usr/share/keyring && \
    wget -qO- "https://pi-apps-coders.github.io/box64-debs/KEY.gpg" | gpg --dearmor -o /usr/share/keyrings/box64-archive-keyring.gpg && \
    wget -qO- "https://pi-apps-coders.github.io/box86-debs/KEY.gpg" | gpg --dearmor -o /usr/share/keyrings/box86-archive-keyring.gpg && \
    echo "Types: deb \n\
URIs: https://Pi-Apps-Coders.github.io/box64-debs/debian \n\
Suites: ./ \n\
Signed-By: /usr/share/keyrings/box64-archive-keyring.gpg" | tee /etc/apt/sources.list.d/box64.sources >/dev/null && \
    echo "Types: deb \n\
URIs: https://Pi-Apps-Coders.github.io/box86-debs/debian \n\
Suites: ./ \n\
Signed-By: /usr/share/keyrings/box86-archive-keyring.gpg" | tee /etc/apt/sources.list.d/box86.sources >/dev/null && \
    dpkg --add-architecture armhf && \
    apt-get update && \
    apt-get -y install box64-generic-arm box86-generic-arm:armhf libc6:armhf libncurses5:armhf libstdc++6:armhf && \
    apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \mkdir steamcmd && \
    wget -O - https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz | tar -xz -C steamcmd && \
    mkdir wine_installs && \
    wget -O - https://github.com/Kron4ek/Wine-Builds/releases/download/11.2/wine-11.2-amd64-wow64.tar.xz | tar -xJ -C wine_installs && \
    ln -s /wine_installs/wine-11.2-amd64-wow64/bin/wine /usr/local/bin && \
    box64 /steamcmd/steamcmd.sh +login anonymous +quit # This seems to do something that allows steamcmd to subsequently install games without having the error: "steamcmd ERROR! Failed to install app ("Missing configuration")"

COPY ./entrypoint.sh /entrypoint.sh
ENTRYPOINT ["bash", "/entrypoint.sh"]
