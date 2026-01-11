# I took this from the following source and modified it to use the latest Ubuntu
# @see https://github.com/kwk/distcc-docker-images/blob/master/Dockerfile
# @see https://developers.redhat.com/blog/2019/05/15/2-tips-to-make-your-c-projects-compile-3-times-faster#tip__2__using_a_distcc_server_container

FROM ubuntu:24.04

ENV LANG=en_US.utf8
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

# Update the package lists
RUN apt update
# Install timezone data to avoid tzdata prompt
RUN apt-get -y install tzdata
# Add some common basic tools and
RUN apt install -y joe vim zsh tmux screen htop curl wget sudo openssl
# Add some developer tools
RUN apt install -y git cmake make ninja-build
# adds the Host compiler, and the cross compiler (13 at the moment)
RUN apt install -y gcc-13 g++-13 gcc-arm-none-eabi clang-20 llvm-20 lld-20 lldb-20 libc++-20-dev libc++abi-20-dev distcc
# Installs developer tools
RUN apt install -y lcov gcovr doxygen graphviz
# Add Python3 and Pip3
RUN apt install -y python3 python3-pip python3-venv python3-setuptools
# Clean up unnecessary packages
RUN apt autoremove --purge -y && apt autoclean -y && rm -rf /var/cache/apt/* /tmp/*

# Distcc port and stats port
# (THIS DOESN'T DO ANYTHING AND YOU HAVE TO MAP THE PORTS YOURSELF WHEN RUNNING THE CONTAINER, ASK ME HOW I KNOW)
EXPOSE 3632/tcp 3633/tcp

ENV HOME=/home/distcc
RUN useradd -s /bin/bash -m distcc
# ENV DISTCC_CMDLIST="/usr/bin/gcc /usr/bin/g++ /usr/bin/c++ /usr/bin/cc /usr/bin/arm-none-eabi-gcc /usr/bin/arm-none-eabi-g++ /usr/bin/arm-none-eabi-c++ /usr/bin/arm-none-eabi-cc"
# # only match the last command (paths should not matter then)
ENV DISTCC_CMDLIST_NUMWORDS=1
ENV DISTCC_DIR=/tmp/distcc

# Mimic Homebrew from Mac OS by making symlinks back to /usr/bin
RUN mkdir -p /opt/homebrew /Applications/ArmGNUToolchain/13.2.Rel1/arm-none-eabi
RUN ln -s /usr/bin /opt/homebrew/bin
RUN ln -s /usr/bin /Applications/ArmGNUToolchain/13.2.Rel1/arm-none-eabi/bin


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
