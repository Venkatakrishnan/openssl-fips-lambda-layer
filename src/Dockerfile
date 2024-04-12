# Define custom function directory
ARG FUNCTION_DIR="/function"

FROM node:20-buster as build-image

# Include global arg in this stage of the build
ARG FUNCTION_DIR

ENV NODE_VERSION v20.12.0
ENV OPEN_SSL_CORE openssl-3.0.13

# Install build dependencies
RUN apt-get update && apt-get install sudo -y
RUN apt-get install g++ -y
RUN apt-get install make -y
RUN apt-get install cmake -y
RUN apt-get install unzip -y
RUN apt-get install perl -y
RUN apt-get install libcurl4-openssl-dev -y

ADD build-fips.sh /
RUN chmod 777 /build-fips.sh && ./build-fips.sh

# Grab a fresh slim copy of the image to reduce the final size
FROM node:20-buster-slim
#FROM public.ecr.aws/lambda/nodejs:20

# Required for Node runtimes which use npm@8.6.0+ because
# by default npm writes logs under /home/.npm and Lambda fs is read-only
#ENV NPM_CONFIG_CACHE=/tmp/.npm

# Copy the function code inside
COPY . ${LAMBDA_TASK_ROOT}

# Copy in the built dependencies
COPY --from=build-image /usr/local/bin /usr/local/bin
COPY --from=build-image /usr/local/lib /usr/local/lib
COPY --from=build-image /usr/local/ssl /usr/local/ssl

# Pass the name of the function handler as an argument to the runtime
CMD ["/bin/bash"]