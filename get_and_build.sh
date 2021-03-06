#!/bin/bash

# Build!
# The default command for `docker run jftr/fairphone2-build-env` is to build as
# specified in thread
# https://forum.fairphone.com/t/compiling-fairphone-open-source/11600
# which is based on instructions from
# http://code.fairphone.com/projects/fp-osos/dev/fairphone-os-build-instructions.html

BLOBS_VERSION="16.12.0"
BLOBS_ARCHIVE="fp2-sibon-${BLOBS_VERSION}-blobs.tgz"

# Initialize repo if it doesn't exist yet
repo > /dev/null || repo init --depth=1 \
	      -u http://code.fairphone.com/gerrit/fp2-dev/manifest \
	      -b fp2-sibon
repo sync -c

# Download and extract blobs
curl http://code.fairphone.com/downloads/FP2/blobs/${BLOBS_ARCHIVE} -C - -O \
	&& BLOBS_SCRIPT=`tar ztf ${BLOBS_ARCHIVE}`
	&& tar zxf ${BLOBS_ARCHIVE} \
	&& yes | sh ${BLOBS_SCRIPT}

# Build
source build/envsetup.sh
choosecombo 1 FP2 2
make -j8
