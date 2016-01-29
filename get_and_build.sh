#!/bin/bash

# Build!
# The default command for `docker run fairphone2-build-env` is to build as
# specified in thread
# https://forum.fairphone.com/t/compiling-fairphone-open-source/11600
# which is based on instructions from
# http://code.fairphone.com/projects/fp-osos/dev/fairphone-os-build-instructions.html

repo init --depth=1 \
              -u http://code.fairphone.com/gerrit/fp2-dev/manifest \
              -b fp2-sibon \
&& repo sync -c  \
&& wget -c http://code.fairphone.com/downloads/FP2/blobs/fp2-sibon-2.0.1-blobs.tgz  \
&& tar zxvf fp2-sibon-2.0.1-blobs.tgz  \
&& yes | sh fp2-sibon-2.0.1-blobs.sh  \
&& source build/envsetup.sh  \
&& choosecombo 1 FP2 2  \
&& make -j8
