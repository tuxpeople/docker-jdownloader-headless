FROM ghcr.io/tuxpeople/baseimage-alpine-light:v3.19

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

# Upgrade and install dependencies
# hadolint ignore=DL3018,DL3019
RUN echo "@community http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk add --no-cache --upgrade openjdk8-jre ca-certificates libstdc++ ffmpeg wget jq moreutils@community && \
    mkdir -p /opt/JDownloader/Downloads /opt/JDownloader/cfg && \
    chown -R abc:abc /opt/JDownloader && \
    chmod -R 775 /opt/JDownloader && \
    chmod g+s /opt/JDownloader

# archive extraction uses sevenzipjbinding library
# which is compiled against libstdc++
COPY --chown=abc:abc ./ressources/${TARGETARCH}/*.jar /opt/JDownloader/libs/
COPY --chown=abc:abc --chmod=774 ./root/ /
COPY --chmod=644 ./config/default-config.json.dist /etc/JDownloader/settings.json.dist

USER abc

WORKDIR /opt/JDownloader
VOLUME /opt/JDownloader/Downloads
VOLUME /opt/JDownloader/cfg

EXPOSE 3129
