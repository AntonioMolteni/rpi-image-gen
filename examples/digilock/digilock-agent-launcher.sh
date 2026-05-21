#!/bin/sh
set -eu

current_bin="/opt/digilock/agent/current/digilock-hw-agent"
fallback_bin="/usr/local/lib/digilock-hw-agent-fallback"

if [ -x "$current_bin" ]; then
  exec "$current_bin"
fi

exec "$fallback_bin"