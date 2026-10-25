#!/bin/sh
# macOS + Xcode command line tools. Writes only to a fresh temporary directory.
set -eu
analysis_dir=$(mktemp -d "${TMPDIR:-/tmp}/firebase-measurement.XXXXXX")
cd "$analysis_dir"
curl --fail --location --output measurement.zip \
  https://dl.google.com/firebase/ios/swiftpm/13.0.1/GoogleAppMeasurement.zip
printf '%s  measurement.zip\n' \
  0b114252276729a5ac2d169e95935c08a79764d0f533863857633b70fb42a922 | shasum -a 256 -c -
unzip -q measurement.zip
mkdir objects
cd objects
ar -x ../GoogleAppMeasurement.xcframework/ios-arm64/GoogleAppMeasurement.framework/GoogleAppMeasurement
for object in APMConsentSettingsUtil APMMeasurement+Event apmpb_measurement_bundle_encoder; do
  xcrun llvm-objdump --macho --disassemble --symbolize-operands "$object.o" > "$object.asm"
done
printf 'Evidence directory: %s\n' "$analysis_dir/objects"
printf 'Open APMConsentSettingsUtil.o in Anatomy, choose Disassembly, and go to address 14c.\n'
