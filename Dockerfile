# I took this from the following source and modified it to use the latest Ubuntu
# @see https://github.com/kwk/distcc-docker-images/blob/master/Dockerfile
# @see https://developers.redhat.com/blog/2019/05/15/2-tips-to-make-your-c-projects-compile-3-times-faster#tip__2__using_a_distcc_server_container

FROM ubuntu:26.04

LABEL org.opencontainers.image.title="distcc-bare-metal-builder" \
      org.opencontainers.image.description="Distcc server with cross-compilation toolchains for bare-metal ARM targets" \
      org.opencontainers.image.source="https://github.com/emrainey/distcc-bare-metal-builder"

ENV LANG=en_US.utf8
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

RUN apt-get update && apt-get install -y \
    clang-22 \
    cmake \
    curl \
    distcc \
    doxygen \
    g++-14 \
    gcc-14 \
    gcc-arm-none-eabi \
    gcovr \
    git \
    graphviz \
    lcov \
    libc++-22-dev \
    libc++abi-22-dev \
    lld-22 \
    lldb-22 \
    llvm-22 \
    make \
    ninja-build \
    openssl \
    python3 \
    python3-pip \
    python3-setuptools \
    python3-venv \
    sudo \
    tzdata \
    wget \
    && arm-none-eabi-gcc --version \
    && apt-get autoremove --purge -y \
    && apt-get autoclean -y \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/* /tmp/*


# Distcc port and stats port
# (THIS DOESN'T DO ANYTHING AND YOU HAVE TO MAP THE PORTS YOURSELF WHEN RUNNING THE CONTAINER, ASK ME HOW I KNOW)
EXPOSE 3632/tcp 3633/tcp

ENV HOME=/home/distcc
RUN adduser --shell /bin/bash --disabled-password --gecos "" distcc
# ENV DISTCC_CMDLIST="/usr/bin/gcc /usr/bin/g++ /usr/bin/c++ /usr/bin/cc /usr/bin/arm-none-eabi-gcc /usr/bin/arm-none-eabi-g++ /usr/bin/arm-none-eabi-c++ /usr/bin/arm-none-eabi-cc"
# # only match the last command (paths should not matter then)
ENV DISTCC_CMDLIST_NUMWORDS=1
ENV DISTCC_DIR=/tmp/distcc

# Mimic Homebrew from Mac OS by making symlinks back to /usr/bin
RUN mkdir -p /opt/homebrew /Applications/ArmGNUToolchain/14.2.Rel1/arm-none-eabi \
    && ln -s /usr/bin /opt/homebrew/bin \
    &&    ln -s /usr/bin /Applications/ArmGNUToolchain/14.2.Rel1/arm-none-eabi/bin

WORKDIR /home/distcc

# Define how to start distccd by default
# (see "man distccd" for more information)
ENTRYPOINT ["distccd", "--daemon", "--no-detach", "--user", "distcc", "--port", "3632", "--stats", "--stats-port", "3633", "--log-stderr", "--listen", "0.0.0.0", "--enable-tcp-insecure"]

# By default the distcc server will accept clients from everywhere.
# Feel free to run the docker image with different values for the
# following params.
CMD ["--allow", "0.0.0.0/0", "--nice", "5", "--jobs", "5"]

# Check the health of the container by checking if the statistics are served.
# (See https://docs.docker.com/engine/reference/builder/#healthcheck)
HEALTHCHECK --interval=5m --timeout=3s CMD curl -f http://0.0.0.0:3633/ || exit 1
