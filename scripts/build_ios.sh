#!/usr/bin/env bash
# Build iOS app for testing (requires macOS + Xcode).
# Output: build/ios/iphoneos/Runner.app (simulator) or archive for TestFlight.

set -euo pipefail
cd "$(dirname "$0")/.."

flutter pub get

echo ""
echo "Building iOS release (no codesign — for simulator or re-signing)..."
flutter build ios --release --no-codesign

echo ""
echo "Done. Next steps:"
echo "  Simulator: open ios/Runner.xcworkspace in Xcode, pick a simulator, Run."
echo "  Device:    open ios/Runner.xcworkspace, set Team, connect iPhone, Run."
echo "  TestFlight: Archive in Xcode -> Distribute App (Apple Developer account required)."
echo ""
