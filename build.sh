#!/bin/bash

# Exit on error
set -e

# Build the Flutter web app
echo "Building Flutter web app..."
flutter build web --release

# Success message
echo "Build completed successfully! The output is in the build/web directory."
