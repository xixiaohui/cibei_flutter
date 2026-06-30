#!/bin/bash

KEYSTORE_PATH="android/app/upload-keystore.jks"

if [ ! -f "$KEYSTORE_PATH" ]; then
  echo "🔐 生成 keystore..."

  keytool -genkeypair \
    -v \
    -keystore $KEYSTORE_PATH \
    -storepass cibei2026 \
    -keypass cibei2026 \
    -keyalg RSA \
    -keysize 2048 \
    -validity 10000 \
    -alias upload \
    -dname "CN=Dev, OU=Dev, O=Company, L=City, S=State, C=CN"

  echo "storePassword=cibei2026" > android/key.properties
  echo "keyPassword=cibei2026" >> android/key.properties
  echo "keyAlias=upload" >> android/key.properties
  echo "storeFile=upload-keystore.jks" >> android/key.properties

else
  echo "🔐 keystore 已存在"
fi