FROM hotio/dotnetcore@sha256:2cc4d58faad8e6230fdfceea898394a0703e14d9b2b5f3d3a47f2dd050acb1a2

ARG DEBIAN_FRONTEND="noninteractive"

EXPOSE 8096

# install packages
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        libass9 libbluray2 libdrm2 libfribidi0 libmp3lame0 libopus0 libtheora0 libva-drm2 libva2 libvdpau1 libvorbis0a libvorbisenc2 libwebp6 libwebpmux3 libx11-6 libx264-152 libx265-146 libzvbi0 ocl-icd-libopencl1 \
        at \
        libfontconfig1 \
        libfreetype6 \
        libdrm-intel1 \
        i965-va-driver \
        mesa-va-drivers && \
# clean up
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

ARG FFMPEG_VERSION

# install ffmpeg
RUN debfile="/tmp/ffmpeg.deb" && curl -fsSL -o "${debfile}" "https://repo.jellyfin.org/releases/server/ubuntu/ffmpeg/jellyfin-ffmpeg_${FFMPEG_VERSION}-bionic_amd64.deb" && dpkg --install "${debfile}" && rm "${debfile}"

ARG JELLYFIN_VERSION
ARG JELLYFIN_WEB_VERSION

# install app
RUN debfile="/tmp/jellyfin.deb" && curl -fsSL -o "${debfile}" "https://repo.jellyfin.org/releases/server/ubuntu/unstable/server/jellyfin-server_${JELLYFIN_VERSION}-unstable_amd64.deb" && dpkg --install "${debfile}" && rm "${debfile}" && \
    debfile="/tmp/jellyfin.deb" && curl -fsSL -o "${debfile}" "https://repo.jellyfin.org/releases/server/ubuntu/unstable/web/jellyfin-web_${JELLYFIN_WEB_VERSION}-unstable_all.deb" && dpkg --install "${debfile}" && rm "${debfile}"

COPY root/ /
