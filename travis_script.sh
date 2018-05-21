set -e

cd ./shared
echo "== Testing on Flutter's stable channel =="
../flutter/bin/flutter test
echo "-- Success --"
echo "== Testing on Flutter's dev channel =="
../flutter-dev/bin/flutter test
echo "-- Success --"
