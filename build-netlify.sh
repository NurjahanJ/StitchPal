#!/bin/bash
set -e

echo "Installing Flutter..."
git clone https://github.com/flutter/flutter.git --depth 1 -b stable $HOME/flutter
export PATH="$PATH:$HOME/flutter/bin"

echo "Flutter version:"
flutter --version

echo "Installing dependencies..."
flutter pub get

echo "Building web app..."
flutter build web --release

echo "Build complete!"
