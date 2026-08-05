#!/usr/bin/env bash

# Target directory for downloaded JARs
TARGET_DIR="."

echo "Downloading dependencies into '$TARGET_DIR'..."
echo "------------------------------------------------"

# Array of Maven Central JAR URLs
URLS=(
  # java-saml-core direct & transitive dependencies
  "https://repo1.maven.org/maven2/com/onelogin/java-saml-core/2.9.0/java-saml-core-2.9.0.jar"
  "https://repo1.maven.org/maven2/org/apache/santuario/xmlsec/2.2.6/xmlsec-2.2.6.jar"
  "https://repo1.maven.org/maven2/org/apache/commons/commons-lang3/3.20.0/commons-lang3-3.20.0.jar"
  "https://repo1.maven.org/maven2/commons-codec/commons-codec/1.18.0/commons-codec-1.18.0.jar"
  "https://repo1.maven.org/maven2/joda-time/joda-time/2.14.2/joda-time-2.14.2.jar"
  "https://repo1.maven.org/maven2/org/slf4j/slf4j-api/1.7.36/slf4j-api-1.7.36.jar"
  "https://repo1.maven.org/maven2/com/fasterxml/woodstox/woodstox-core/6.5.1/woodstox-core-6.5.1.jar"
  "https://repo1.maven.org/maven2/org/codehaus/woodstox/stax2-api/4.2.2/stax2-api-4.2.2.jar"
  "https://repo1.maven.org/maven2/ch/qos/reload4j/reload4j/1.2.26/reload4j-1.2.26.jar"

  # axis-1 direct & transport dependencies
  "https://repo1.maven.org/maven2/commons-logging/commons-logging/1.3.4/commons-logging-1.3.4.jar"
  "https://repo1.maven.org/maven2/commons-discovery/commons-discovery/0.5/commons-discovery-0.5.jar"
  "https://repo1.maven.org/maven2/wsdl4j/wsdl4j/1.6.3/wsdl4j-1.6.3.jar"
  "https://repo1.maven.org/maven2/axis/axis-jaxrpc/1.4/axis-jaxrpc-1.4.jar"
  "https://repo1.maven.org/maven2/axis/axis-saaj/1.4/axis-saaj-1.4.jar"
)

# Counter for failed downloads
FAILED_COUNT=0

# Download each JAR
for url in "${URLS[@]}"; do
  filename=$(basename "$url")
  filepath="$TARGET_DIR/$filename"

  if [ -f "$filepath" ]; then
    echo "[EXISTS] Skipping $filename"
  else
    echo "[DOWNLOADING] $filename..."
    
    # Run wget and capture exit status
    if ! wget -q --show-progress -P "$TARGET_DIR" "$url"; then
      echo "ERROR: Failed to download $filename from $url" >&2
      ((FAILED_COUNT++))
    fi
  fi
done

echo "------------------------------------------------"
if [ "$FAILED_COUNT" -gt 0 ]; then
  echo "Finished with errors: $FAILED_COUNT file(s) failed to download." >&2
  exit 1
else
  echo "Done! All JARs are located in $TARGET_DIR"
fi