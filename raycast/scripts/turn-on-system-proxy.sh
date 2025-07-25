#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Turn on System Proxy
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.description Turn on the system proxy

networksetup -setsecurewebproxy "Wi-Fi" "proxy.internal" 5451
networksetup -setsecurewebproxystate "Wi-Fi" on

echo "The system proxy has been enabled!"
