#!/bin/bash
set -euo pipefail

set -a
# shellcheck source=/dev/null
source /etc/restic/restic.conf
set +a

restic "$@"
