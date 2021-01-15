#!/bin/bash
set -euo pipefail

main() {
    export DEBIAN_FRONTEND=noninteractive

    apt-get --quiet=2 update
    apt-get --quiet=2 install --no-install-recommends "$@"

    # Clean up.
    rm -rf \
       /var/log/apt/* \
       /var/log/dpkg.log \
       /var/lib/apt/lists/*
}

main "$@"
