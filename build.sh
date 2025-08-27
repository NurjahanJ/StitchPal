#!/bin/bash

# Exit on error
set -e

# Install Flutter
git clone https://github.com/flutter/flutter.git --depth 1 -b stable flutter
export PATH="$PATH:`pwd`/flutter/bin"

# Check Flutter and install dependencies
flutter doctor -v
flutter pub get

# Build for web
flutter build web --release
