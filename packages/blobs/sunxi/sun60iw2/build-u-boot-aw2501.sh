#!/bin/bash
# Rebuild the vendor package on an x86_64 host with Docker. Never installs it.
# Usage: bash build-u-boot-aw2501.sh /absolute/path/to/new-output-directory
# Vendor tools use fixed /tmp paths; keep those writes inside the container.
set -euo pipefail
directory=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
if [[ "${1:-}" != --container ]]; then
    [[ $# == 1 && "$1" == /* && ! -e "$1" ]] || {
        echo "Usage: $0 /absolute/path/to/new-output-directory" >&2
        exit 1
    }
    mkdir -- "$1"
    cp "${directory}/u-boot-aw2501-ddr.patch" "$1/"
    cp "${BASH_SOURCE[0]}" "$1/build.sh"
    docker build --platform linux/amd64 -t sun60iw2-bootloader-build \
        -f "${directory}/u-boot-aw2501-build.Dockerfile" "${directory}"
    docker image inspect sun60iw2-bootloader-build > "$1/build-image.json"
    docker run --rm --platform linux/amd64 -v "$1:/work" \
        sun60iw2-bootloader-build bash /work/build.sh --container 2>&1 | tee "$1/build.log"
    exit
fi

test "$(uname -m)" = x86_64
cd /work
test ! -e build-package
git clone --no-checkout https://github.com/radxa-pkg/u-boot-aw2501.git build-package
cd build-package
git checkout --detach 8c9fcff14d8014a01e3973f50e016ee4ff5cbbae
git apply --index /work/u-boot-aw2501-ddr.patch
git submodule update --init --recursive
test "$(git -C device-a733 rev-parse HEAD)" = 79d54f44e14111db3845096cef0639a6c9222707
dpkg-checkbuilddeps
git submodule status --recursive > /work/package-source-pins.txt
make arisc/ar100s/tools/riscv64-elf-x86_64-20201104.tar.gz \
    toolchains/gcc-linaro-7.2.1-2017.11-x86_64_arm-linux-gnueabi.tar.xz
sha256sum --check <<'CHECKSUMS'
c0b9197b25e9778afffbcda649f3e1d4cc3555fe0bed70e9aaf5730d90a70530  arisc/ar100s/tools/riscv64-elf-x86_64-20201104.tar.gz
89e9bfc7ffe615f40a72c2492df0488f25fc20404e5f474501c8d55941337f71  toolchains/gcc-linaro-7.2.1-2017.11-x86_64_arm-linux-gnueabi.tar.xz
CHECKSUMS
sha256sum arisc/ar100s/tools/riscv64-elf-x86_64-20201104.tar.gz \
    toolchains/gcc-linaro-7.2.1-2017.11-x86_64_arm-linux-gnueabi.tar.xz \
    > /work/toolchain-sha256.txt
tar -xJf toolchains/gcc-linaro-7.2.1-2017.11-x86_64_arm-linux-gnueabi.tar.xz -C toolchains
make deb
cd /work
sha256sum ./*.deb > package-sha256.txt
