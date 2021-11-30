FROM ghcr.io/tuxpeople/baseimage-alpine:3.14.3

# set args
ARG BUILD_DATE
ARG VERSION
ARG TARGETARCH
ARG TARGETPLATFORM
ARG NAME

# set env
ENV LD_LIBRARY_PATH=/lib;/lib32;/usr/lib
ENV XDG_DOWNLOAD_DIR=/opt/JDownloader/Downloads
ENV UMASK=''
ENV LC_CTYPE="en_US.UTF-8"
ENV LANG="en_US.UTF-8"
ENV LC_COLLATE="C"
ENV LANGUAGE="C.UTF-8"
ENV LC_ALL="C.UTF-8"

# ARG TARGETPLATFORM
# ARG BUILDPLATFORM
# ARG TARGETOS
# ARG TARGETARCH
# ARG TARGETVARIANT
# RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM"
# RUN echo "$TARGETPLATFORM consists of $TARGETOS, $TARGETARCH and $TARGETVARIANT"

WORKDIR /opt/JDownloader
VOLUME /opt/JDownloader/Downloads
VOLUME /opt/JDownloader/cfg

# Upgrade and install dependencies
# hadolint ignore=DL3018,DL3019
RUN echo "@community http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk add --no-cache --upgrade openjdk8-jre ca-certificates libstdc++ ffmpeg wget jq moreutils@community && \
    wget -q -O /opt/JDownloader/JDownloader.jar --user-agent="Github Docker Image Build (https://github.com/tuxpeople)" "http://installer.jdownloader.org/JDownloader.jar" && \
    chmod +x /opt/JDownloader/JDownloader.jar && \
    chmod -R 777 /opt/JDownloader* /tmp/init

# archive extraction uses sevenzipjbinding library
# which is compiled against libstdc++
COPY ./ressources/${TARGETARCH}/*.jar /opt/JDownloader/libs/
COPY ./root/ /
COPY ./config/default-config.json.dist /opt/JDownloader/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json.dist
COPY ./scripts/configure.sh /usr/bin/configure

EXPOSE 3129
