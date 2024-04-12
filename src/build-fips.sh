#!/bin/bash -e

# Versions to build
opensslcore=$OPEN_SSL_CORE
echo $opensslcore

# Create a working directory
cd "$(dirname $0)/.."
rm -rf dist
mkdir -p dist
cd dist

# Download openssl source code package
curl -s "https://www.openssl.org/source/$opensslcore.tar.gz" > "$opensslcore.tar.gz"

# Assuming the packages downloaded successfully
# Next Unpack the package
tar xzvf "$opensslcore.tar.gz"

# Then build OpenSSL with FIPS support
pushd "$opensslcore"
    ./Configure enable-fips
   echo "* Building FIPS modules"
   sudo make install
popd