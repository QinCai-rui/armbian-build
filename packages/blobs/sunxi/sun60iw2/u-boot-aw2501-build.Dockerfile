FROM ubuntu:24.04@sha256:24737cef17f4e22b1977df7d9a05e77c4e28b7da5b8911f8d8ccda136bf3573c
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates git wget xz-utils file build-essential crossbuild-essential-armel \
    debhelper devscripts lintian dh-exec flex bison python3-setuptools swig \
    python3-dev libgnutls28-dev python3-pyelftools libncurses-dev xxd bc \
    lib32stdc++6 lib32z1 dos2unix gdisk device-tree-compiler libssl-dev \
    unzip rsync && rm -rf /var/lib/apt/lists/*
WORKDIR /work
