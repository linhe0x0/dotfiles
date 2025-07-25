#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Turn off System Proxy
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.description Turn off the System Proxy

networksetup -setsecurewebproxystate "Wi-Fi" off

echo "The system proxy has been disabled!"
