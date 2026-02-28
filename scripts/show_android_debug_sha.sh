set -euo pipefail

KEYSTORE_PATH="${HOME}/.android/debug.keystore"

if [[ ! -f "${KEYSTORE_PATH}" ]]; then
  echo "Debug keystore not found at ${KEYSTORE_PATH}"
  echo "Run your Flutter app once on Android, then run this script again."
  exit 1
fi

keytool -list -v \
  -alias androiddebugkey \
  -keystore "${KEYSTORE_PATH}" \
  -storepass android \
  -keypass android | grep -E "Alias name:|Owner:|Valid from:|SHA1:|SHA256:"
