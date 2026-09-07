#!/bin/sh
set -eu

repository_root=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
cd "$repository_root"
. "$repository_root/scripts/lib/environment.sh"

resolve_xcode_developer_dir
run_tuist generate "$@"
