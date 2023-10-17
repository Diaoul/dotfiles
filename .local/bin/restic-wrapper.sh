#!/bin/bash
set -euo pipefail

source /etc/restic/restic.conf
export $(sed '/^#/d' /etc/restic/restic.conf | cut -d= -f1)

restic $@
