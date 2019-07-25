#!/usr/bin/env bash

# This relies on either:
#   1. You being authenticated locally with CocoaPods trunk.
#   2. The `COCOAPODS_TRUNK_TOKEN` environment variable being set.

set -euo pipefail

function step { >&2 echo -e "\033[1m\033[36m* $@\033[0m"; }
function finish { >&2 echo -en "\033[0m"; }
trap finish EXIT

step "Pushing release to CocoaPods…"

if [[ $CIRCLE_TAG ]]; then
  # pod trunk push platform/ios/Mapbox-iOS-SDK.podspec --allow-warnings
  echo "Would have pushed to CocoaPods trunk!"
else
  echo "Skipping push to CocoaPods trunk for untagged build"
fi

step "Pushing release/builds to Mapbox pod-specs repo…"

pod repo add mapbox-public https://github.com/mapbox/pod-specs

if [[ $CIRCLE_TAG ]]; then
  # pod repo push mapbox-public platform/ios/Mapbox-iOS-SDK.podspec --allow-warnings
  # pod repo push mapbox-public platform/ios/Mapbox-iOS-SDK-stripped.podspec --allow-warnings
  echo "Would have pushed tagged builds to mapbox-public!"
else
  echo "Skipping push of release podspecs to mapbox-public for untagged build"
fi

# pod repo push mapbox-public platform/ios/Mapbox-iOS-SDK-snapshot-dynamic.podspec --allow-warnings
echo "Skipping push to mapbox-public until we have a way to update the versions in the snapshot podspec"
