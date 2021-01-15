#!/bin/bash
set -euo pipefail

main() {
    <<EOF install -m644 /dev/stdin /usr/share/applications/mimeapps.list
[Default Applications]
x-scheme-handler/afirma=afirma.desktop
EOF
}

main "$@"
