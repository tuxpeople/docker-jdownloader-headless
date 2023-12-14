FROM debian:bookworm-20231120-slim as builder

COPY fetcher.sh .

ADD --chmod=774 http://installer.jdownloader.org/JDownloader.jar /staging/JDownloader/JDownloader.jar

RUN mkdir -p /staging/JDownloader/Downloads /staging/JDownloader/cfg && \
    useradd nonroot && \
    chown -R nonroot:nonroot /staging/JDownloader && \
    chmod -R 775 /staging/JDownloader && \
    chmod g+s /staging/JDownloader
# hadolint ignore=DL3008,DL3009
RUN ./fetcher.sh ffmpeg wget jq moreutils

FROM gcr.io/distroless/java17-debian12:debug

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

COPY --from=builder /staging/root /
COPY --from=builder /staging/status /var/lib/dpkg/status.d
COPY --from=builder --chown=nonroot:nonroot /staging/JDownloader /opt/JDownloader

# ARG TARGETPLATFORM
# ARG BUILDPLATFORM
# ARG TARGETOS
# ARG TARGETARCH
# ARG TARGETVARIANT
# RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM"
# RUN echo "$TARGETPLATFORM consists of $TARGETOS, $TARGETARCH and $TARGETVARIANT"


# archive extraction uses sevenzipjbinding library
# which is compiled against libstdc++
COPY --chown=nonroot:nonroot ./ressources/${TARGETARCH}/*.jar /opt/JDownloader/libs/
COPY --chown=nonroot:nonroot --chmod=774 ./root/ /
COPY --chmod=644 ./config/default-config.json.dist /etc/JDownloader/settings.json.dist

USER nonroot

WORKDIR /opt/JDownloader
VOLUME /opt/JDownloader/Downloads
VOLUME /opt/JDownloader/cfg

EXPOSE 3129
ENTRYPOINT ["sh", "-c", "run-parts /scripts; /docker-entrypoint.sh"]