#!/bin/sh
set -eu

bind="${DIGILOCK_API_BIND:-127.0.0.1:7080}"
echo "digilock-hw-agent placeholder started on ${bind}" >&2

# Placeholder loop. Replace with your real peripheral bus handlers and API server.
while true; do
  sleep 60
done