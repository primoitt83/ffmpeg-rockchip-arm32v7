## ffmpeg-rockchip
FROM alpine:3.18.5 as build-ffmpeg

RUN apk add --no-cache \
  coreutils \
  wget \
  rust cargo cargo-c \
  openssl-dev openssl-libs-static \
  ca-certificates \
  bash \
  tar \
  build-base \
  autoconf automake \
  libtool \
  diffutils \
  cmake meson ninja \
  git \
  yasm nasm \
  texinfo \
  jq \
  zlib-dev zlib-static \
  bzip2-dev bzip2-static \
  libxml2-dev libxml2-static \
  expat-dev expat-static \
  fontconfig-dev fontconfig-static \
  freetype freetype-dev freetype-static \
  graphite2-static \
  glib-static \
  tiff tiff-dev \
  libjpeg-turbo libjpeg-turbo-dev \
  libpng-dev libpng-static \
  giflib giflib-dev \
  harfbuzz-dev harfbuzz-static \
  fribidi-dev fribidi-static \
  brotli-dev brotli-static \
  soxr-dev soxr-static \
  tcl \
  numactl-dev \
  cunit cunit-dev \
  fftw-dev \
  libsamplerate-dev libsamplerate-static \
  vo-amrwbenc-dev vo-amrwbenc-static \
  snappy snappy-dev snappy-static \
  xxd \
  xz-dev xz-static \
  linux-headers \
  bsd-compat-headers \
  alsa-utils alsaconf alsa-utils-doc alsa-lib alsa-lib-dev \
  pulseaudio pulseaudio-dev pulseaudio-alsa alsa-plugins-pulse pulseaudio-utils

ARG CFLAGS="-O3 -static-libgcc -fno-strict-overflow -fstack-protector-all -fPIC"
ARG CXXFLAGS="-O3 -static-libgcc -fno-strict-overflow -fstack-protector-all -fPIC"
ARG LDFLAGS="-Wl,-z,relro,-z,now"
ARG WGET_OPTS="--retry-on-host-error --retry-on-http-error=429,500,502,503"
ARG TAR_OPTS="--no-same-owner --extract --file"

RUN sed -i 's/libbrotlidec/libbrotlidec, libbrotlicommon/' /usr/lib/pkgconfig/freetype2.pc

## mpp
RUN \
  cd /opt && \
  git clone --branch mpp-dev https://github.com/JeffyCN/mirrors.git --depth=1 && \
  cd /opt/mirrors && \
  cmake -DRKPLATFORM=ON -DHAVE_DRM=ON -DBUILD_SHARED_LIBS=OFF && \
  make -j$(nproc) && make install

## libdrm
RUN \
  git clone git://anongit.freedesktop.org/git/mesa/drm && \
  cd drm && \
  meson build --default-library static && \
  cd build && \
  ninja install

## rga
RUN \
  git clone --branch linux-rga-multi https://github.com/JeffyCN/mirrors.git --depth=1 && \
  cd mirrors && \
  meson build --default-library static && \
  cd build && \
  ninja install

## libyuv
RUN \
  git clone https://chromium.googlesource.com/libyuv/libyuv/ && \
  cd libyuv && \
  cmake -DCMAKE_BUILD_TYPE="Release" -DBUILD_SHARED_LIBS=OFF && \
  make -j$(nproc) && make install 

## libass
ARG LIBASS_VERSION=0.17.1
ARG LIBASS_URL="https://github.com/libass/libass/releases/download/$LIBASS_VERSION/libass-$LIBASS_VERSION.tar.gz"
ARG LIBASS_SHA256=d653be97198a0543c69111122173c41a99e0b91426f9e17f06a858982c2fb03d
RUN \
  wget $WGET_OPTS -O libass.tar.gz "$LIBASS_URL" && \
  echo "$LIBASS_SHA256  libass.tar.gz" | sha256sum --status -c - && \
  tar $TAR_OPTS libass.tar.gz && \
  cd libass-* && ./configure --disable-shared --enable-static && \
  make -j$(nproc) && make install

## lib_fdkaac
ARG FDK_AAC_VERSION=2.0.2
ARG FDK_AAC_URL="https://github.com/mstorsjo/fdk-aac/archive/v$FDK_AAC_VERSION.tar.gz"
ARG FDK_AAC_SHA256=7812b4f0cf66acda0d0fe4302545339517e702af7674dd04e5fe22a5ade16a90
RUN \
  wget $WGET_OPTS -O fdk-aac.tar.gz "$FDK_AAC_URL" && \
  echo "$FDK_AAC_SHA256  fdk-aac.tar.gz" | sha256sum --status -c - && \
  tar $TAR_OPTS fdk-aac.tar.gz && \
  cd fdk-aac-* && ./autogen.sh && ./configure --disable-shared --enable-static && \
  make -j$(nproc) install

## lame
ARG MP3LAME_VERSION=3.100
ARG MP3LAME_URL="https://sourceforge.net/projects/lame/files/lame/$MP3LAME_VERSION/lame-$MP3LAME_VERSION.tar.gz/download"
ARG MP3LAME_SHA256=ddfe36cab873794038ae2c1210557ad34857a4b6bdc515785d1da9e175b1da1e
RUN \
  wget $WGET_OPTS -O lame.tar.gz "$MP3LAME_URL" && \
  echo "$MP3LAME_SHA256  lame.tar.gz" | sha256sum --status -c - && \
  tar $TAR_OPTS lame.tar.gz && \
  cd lame-* && ./configure --disable-shared --enable-static --enable-nasm --disable-gtktest --disable-cpml --disable-frontend && \
  make -j$(nproc) install

## opus
ARG OPUS_VERSION=1.4
ARG OPUS_URL="https://github.com/xiph/opus/releases/download/v$OPUS_VERSION/opus-$OPUS_VERSION.tar.gz"
ARG OPUS_SHA256=c9b32b4253be5ae63d1ff16eea06b94b5f0f2951b7a02aceef58e3a3ce49c51f
RUN \
  wget $WGET_OPTS -O opus.tar.gz "$OPUS_URL" && \
  echo "$OPUS_SHA256  opus.tar.gz" | sha256sum --status -c - && \
  tar $TAR_OPTS opus.tar.gz && \
  cd opus-* && ./configure --disable-shared --enable-static --disable-extra-programs --disable-doc && \
  make -j$(nproc) install

## librtmp
ARG LIBRTMP_URL="https://git.ffmpeg.org/rtmpdump.git"
ARG LIBRTMP_COMMIT=f1b83c10d8beb43fcc70a6e88cf4325499f25857
RUN \
  git clone "$LIBRTMP_URL" && \
  cd rtmpdump && git checkout $LIBRTMP_COMMIT && \
  # Patch/port librtmp to openssl 1.1
  for _dlp in dh.h handshake.h hashswf.c; do \
    wget $WGET_OPTS https://raw.githubusercontent.com/microsoft/vcpkg/38bb87c5571555f1a4f64cb4ed9d2be0017f9fc1/ports/librtmp/${_dlp%.*}.patch; \
    patch librtmp/${_dlp} < ${_dlp%.*}.patch; \
  done && \
  make SYS=posix SHARED=off -j$(nproc) install

## libspeex
ARG SPEEX_VERSION=1.2.1
ARG SPEEX_URL="https://github.com/xiph/speex/archive/Speex-$SPEEX_VERSION.tar.gz"
ARG SPEEX_SHA256=beaf2642e81a822eaade4d9ebf92e1678f301abfc74a29159c4e721ee70fdce0
RUN \
  wget $WGET_OPTS -O speex.tar.gz "$SPEEX_URL" && \
  echo "$SPEEX_SHA256  speex.tar.gz" | sha256sum --status -c - && \
  tar $TAR_OPTS speex.tar.gz && \
  cd speex-Speex-* && ./autogen.sh && ./configure --disable-shared --enable-static && \
  make -j$(nproc) install

## libwebp
ARG LIBWEBP_VERSION=1.3.2
ARG LIBWEBP_URL="https://github.com/webmproject/libwebp/archive/v$LIBWEBP_VERSION.tar.gz"
ARG LIBWEBP_SHA256=c2c2f521fa468e3c5949ab698c2da410f5dce1c5e99f5ad9e70e0e8446b86505
RUN \
  wget $WGET_OPTS -O libwebp.tar.gz "$LIBWEBP_URL" && \
  echo "$LIBWEBP_SHA256  libwebp.tar.gz" | sha256sum --status -c - && \
  tar $TAR_OPTS libwebp.tar.gz && \
  cd libwebp-* && ./autogen.sh && ./configure --disable-shared --enable-static --with-pic --enable-libwebpmux --disable-libwebpextras --disable-libwebpdemux --disable-sdl --disable-gl --disable-png --disable-jpeg --disable-tiff --disable-gif && \
  make -j$(nproc) install

## libx264
ARG X264_URL="https://code.videolan.org/videolan/x264.git"
ARG X264_VERSION=31e19f92f00c7003fa115047ce50978bc98c3a0d
RUN \
  git clone "$X264_URL" && \
  cd x264 && \
  git checkout $X264_VERSION && \
  ./configure --enable-pic --enable-static --disable-cli --disable-lavf --disable-swscale && \
  make -j$(nproc) install

## ffmpeg-rockchip
RUN \
  git clone --branch mpp-rga-ffmpeg-6 https://github.com/hbiyik/FFmpeg.git --depth=1 && \
  cd FFmpeg && \
  ./configure \
  --pkg-config-flags="--static" \
  --extra-cflags="-fopenmp" \
  --extra-ldflags="-fopenmp -Wl,-z,stack-size=2097152" \
  --toolchain=hardened \
  --extra-libs="-lpthread -lm" \
  --ld="g++" \
  --disable-debug \
  --disable-ffplay \
  --disable-shared \
  --disable-doc \
  --enable-static \  
  --enable-gpl \
  --enable-nonfree \
  --enable-version3 \
  --enable-libfdk-aac \
  --enable-libdrm \
  --enable-rkmpp \
  --enable-neon \
  --enable-fontconfig \
  --enable-indev=alsa \
  --enable-outdev=alsa \
  --enable-libpulse \
  --enable-libass \
  --enable-libfreetype \
  --enable-libfribidi \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-librtmp \
  --enable-libspeex \
  --enable-libwebp \
  --enable-libx264 \
  --enable-openssl \
  || (cat ffbuild/config.log ; false) \
  && make -j$(nproc) install

## Run copy-libs script
COPY ./copy-libs.sh /
WORKDIR /
RUN chmod +x copy-libs.sh
RUN ./copy-libs.sh

# Cleanup.
RUN rm -rf /var/cache/* /tmp/*

##########################
# Build the release image.
FROM alpine:3.18.5

RUN apk add --no-cache \
  ca-certificates \
  gettext \
  openssl \
  pcre \
  curl \
  alsa-utils

# Cleanup.
RUN rm -rf /var/cache/* /tmp/*

RUN mkdir /usr/lib/pulseaudio

COPY --from=build-ffmpeg /usr/local /usr/local
COPY --from=build-ffmpeg /usr_lib/. /usr/lib
COPY --from=build-ffmpeg /usr_local_lib/. /usr/local/lib
COPY --from=build-ffmpeg /usr_lib_pulseaudio/. /usr/lib/pulseaudio

RUN chmod +x /usr/local/bin/ffmpeg
RUN chmod +x /usr/local/bin/ffprobe

CMD ffmpeg -buildconf