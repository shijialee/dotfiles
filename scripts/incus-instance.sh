#!/usr/bin/env bash
set -euo pipefail

project="$1"
workspace="$HOME/projects/$project"

test -d "$workspace" || {
    echo "Workspace does not exist: $workspace"
    exit 1
}

uid="$(id -u)"
gid="$(id -g)"

incus init ai-base "$project" \
    --profile default \
    --profile ai-sandbox

# map host user to root inside container
incus config set "$project" raw.idmap \
"uid $uid 0
gid $gid 0"


incus config device add "$project" workspace disk \
    source="$workspace" \
    path=/workspace

incus config device add "$project" gitdir disk \
    source="$workspace/.git" \
    path=/workspace/.git \
    readonly=true

incus start "$project"
