FROM ubuntu:14.04

MAINTAINER docker@jftr.de

# Add 32bit architechture to enable 32bit crosscompilation
RUN dpkg --add-architecture i386

# Prepare the Build Environment
RUN apt-get update && apt-get install -y -f --no-install-recommends \
    openjdk-7-jdk \
    bison \
    g++-multilib \
    git \
    gperf \
    libxml2-utils \
    make \
    python-networkx \
    zlib1g-dev:i386 \
    zip \
    unzip \
    curl \
    wget \
    ca-certificates \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Install repo
RUN mkdir -p /usr/local/repo/bin \
 && curl --tlsv1 https://storage.googleapis.com/git-repo-downloads/repo > \
    /usr/local/repo/bin/repo \
 && chmod +x /usr/local/repo/bin/repo
ENV PATH /usr/local/repo/bin:$PATH

# Create working directory
RUN mkdir -p /var/fairphone_os/
WORKDIR /var/fairphone_os/

# Build!
# The default command for `docker run fairphone2-build-env` is to build as
# specified in thread
# https://forum.fairphone.com/t/compiling-fairphone-open-source/11600
# which is based on instructions from
# http://code.fairphone.com/projects/fp-osos/dev/fairphone-os-build-instructions.html
CMD ["/bin/bash", "-c", \
        "repo init --depth=1 \
              -u http://code.fairphone.com/gerrit/fp2-dev/manifest \
              -b fp2-sibon \
         && repo sync -c \
         && wget -c http://code.fairphone.com/downloads/FP2/blobs/fp2-sibon-2.0.0-blobs.tgz \
         && tar zxvf fp2-sibon-2.0.0-blobs.tgz \
         && yes | sh fp2-sibon-2.0.0-blobs.sh \
         && source build/envsetup.sh \
         && cp -v vendor/qcom/proprietary/target/product/FP2/obj/lib/*.so \
                ./vendor/qcom/proprietary/target/product/FP2/system/vendor/lib/ \
         && choosecombo 1 FP2 2 \
         && make -j8"]

# Other commands can be executed with `docker run fairphone2-build-env <command>` or
# you can work in an interactive shell with
# `docker run -i -t <this-image> /bin/bash`

