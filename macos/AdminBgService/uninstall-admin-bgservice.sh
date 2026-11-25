#!/bin/bash
set -euo pipefail

# Removes the VPN service that install-admin-bgservice.sh installed:
#   sudo "…/Resources/TunnelService/uninstall-tunnel-service.sh"

task_destination="/Library/Application Support/Hiddify/AdminBgService/Hiddify.app"
task_legacy="/Library/Application Support/Hiddify/TunnelService/Hiddify.app"

if [[ "$(id -u)" != 0 ]]; then
  echo 'error: run this script with sudo.' >&2
  exit 1
fi
for task_old in "$task_destination/Contents/MacOS/UnsungHero" "$task_destination/Contents/MacOS/Hiddify" \
  "$task_legacy/Contents/MacOS/Hiddify"; do
  if [[ -x "$task_old" ]]; then
    "$task_old" --tunnel uninstall || true
    break
  fi
done
# Drop both the current and pre-rename install trees.
rm -rf "/Library/Application Support/Hiddify/AdminBgService" \
  "/Library/Application Support/Hiddify/TunnelService"
rmdir "/Library/Application Support/Hiddify" 2>/dev/null || true
echo 'UnsungHero VPN service removed.'
