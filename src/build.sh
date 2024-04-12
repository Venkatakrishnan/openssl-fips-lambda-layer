#!/bin/sh

#arm64 builds on Mac M1-3 processors linux/amd64 Or 
#x86_64 builds for 64 bit processors linux/arm64

architecture=linux/amd64

rm lambda-layer-openssl.zip
#arm64 builds on Mac M1-3 processors
#docker image build -t openssl-layer --platform linux/arm64 . 

docker image build -t openssl-layer --platform ${architecture} . 

repo="openssl-layer"
tag="latest"
image=${repo}:${tag}
container_name="cont-$(date +%s)"

# The variables below should be updated to suit a project's need
cmd=/build.sh
path_to_copy=/usr/local
output_dir=./layer

# Run the container & Pass the command to execute, this will override CMD in the Dockerfile 
#--platform linux/amd64 \  #x86_64 builds Or --platform linux/arm64 \   #arm64 builds
docker run \
--platform ${architecture} \
--name ${container_name} \
${image}

sudo rm -rf ${output_dir}
mkdir -p ${output_dir}

# Copy files from the container filesystem to host
sudo docker cp ${container_name}:${path_to_copy} ${output_dir}

# Data copied, delete the container
docker container rm --force --volumes ${container_name}

#zip the package up for lambda layer (ditto for Mac)
#ditto -c -k --sequesterRsrc --keepParent ${output_dir} lambda-layer-openssl.zip
zip -r lambda-layer-openssl.zip ${output_dir}