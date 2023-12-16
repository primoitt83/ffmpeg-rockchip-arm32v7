#!/bin/sh

mkdir /usr_lib
mkdir /usr_local_lib
mkdir /usr_lib_pulseaudio

# fisrt copy loop
for file in `echo libasound.so \
  libasound.so.2 \
  libasound.so.2.0.0 \
  libasyncns.so.0 \
  libasyncns.so.0.3.1 \
  libbrotlicommon.so \
  libbrotlicommon.so.1 \
  libbrotlicommon.so.1.0.9 \
  libbrotlidec.so \
  libbrotlidec.so.1 \
  libbrotlidec.so.1.0.9 \
  libbsd.so.0 \
  libbsd.so.0.11.7 \
  libbz2.so \
  libbz2.so.1 \
  libbz2.so.1.0.8 \
  libdbus-1.so.3 \
  libdbus-1.so.3.32.3 \
  libexpat.so \
  libexpat.so.1 \
  libexpat.so.1.8.10 \
  libFLAC.so.12 \
  libFLAC.so.12.1.0 \
  libfontconfig.so \
  libfontconfig.so.1 \
  libfontconfig.so.1.12.0 \
  libfreetype.so \
  libfreetype.so.6 \
  libfreetype.so.6.19.0 \
  libfribidi.so \
  libfribidi.so.0 \
  libfribidi.so.0.4.0 \
  libgcc_s.so \
  libgcc_s.so.1 \
  libglib-2.0.so \
  libglib-2.0.so.0 \
  libglib-2.0.so.0.7600.4 \
  libgraphite2.so \
  libgraphite2.so.3 \
  libgraphite2.so.3.2.1 \
  libharfbuzz.so \
  libharfbuzz.so.0 \
  libharfbuzz.so.0.60730.0 \
  libintl.so \
  libintl.so.8 \
  libintl.so.8.3.0 \
  libjpeg.so \
  libjpeg.so.8 \
  libjpeg.so.8.2.2 \
  liblzma.so \
  liblzma.so.5 \
  liblzma.so.5.4.3 \
  libmd.so.0 \
  libmd.so.0.0.5 \
  libogg.so.0 \
  libogg.so.0.8.5 \
  libopus.so.0 \
  libopus.so.0.9.0 \
  libpcre2-8.so \
  libpcre2-8.so.0 \
  libpcre2-8.so.0.11.2 \
  libpng16.so \
  libpng16.so.16 \
  libpng16.so.16.39.0 \
  libpulsecommon-16.1.so \
  libpulse.so \
  libpulse.so.0 \
  libpulse.so.0.24.2 \
  libsndfile.so.1 \
  libsndfile.so.1.0.35 \
  libstdc++.so \
  libstdc++.so.6 \
  libstdc++.so.6.0.30 \
  libvorbisenc.so.2 \
  libvorbisenc.so.2.0.12 \
  libvorbis.so.0 \
  libvorbis.so.0.4.9 \
  libXau.so \
  libXau.so.6 \
  libXau.so.6.0.0 \
  libxcb-shape.so \
  libxcb-shape.so.0 \
  libxcb-shape.so.0.0.0 \
  libxcb-shm.so \
  libxcb-shm.so.0 \
  libxcb-shm.so.0.0.0 \
  libxcb.so \
  libxcb.so.1 \
  libxcb.so.1.1.0 \
  libxcb-xfixes.so \
  libxcb-xfixes.so.0 \
  libxcb-xfixes.so.0.0.0 \
  libXdmcp.so \
  libXdmcp.so.6 \
  libXdmcp.so.6.0.0 \
  libpulse.so.0.24.2 \
  libpulse.so.0 \
  libpulse.so`; do \
  cp /usr/lib/$file /usr_lib; done

# second copy loop
for file in `echo librga.so \
  librga.so.2 \
  librga.so.2.1.0 \
  librockchip_mpp.so \
  librockchip_mpp.so.0 \
  librockchip_mpp.so.1 \
  libyuv.so`; do \
  cp /usr/local/lib/$file /usr_local_lib; done

# third copy loop
for file in `echo libpulsecommon-16.1.so \
  libpulsecore-16.1.so \
  libpulsedsp.so`; do \
  cp /usr/lib/pulseaudio/$file /usr_lib_pulseaudio; done