set -e

cd ./shared

echo "== Testing on Flutter's $FLUTTER_VERSION channel =="
../flutter/bin/flutter test
echo "-- Success --"
