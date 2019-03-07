# NOTE: Multi-stage Build

FROM alpine:3.7 as graalvm_download

ENV GRAALVM_VERSION=1.0.0-rc13

RUN apk add --no-cache curl

# Download GraalVM and Install
RUN curl -L https://github.com/oracle/graal/releases/download/vm-$GRAALVM_VERSION/graalvm-ce-$GRAALVM_VERSION-linux-amd64.tar.gz | tar zxf - && \
    mv /graalvm-ce-$GRAALVM_VERSION /graalvm-ce



FROM node:10.15-alpine as piping_bundle

# Copy to /piping-server
COPY . /piping-server

# Create bundled Piping Server
RUN cd /piping-server && \
    npm install && \
    npm run bundle



# (base image info from: https://masahito.hatenablog.com/entry/2018/06/24/223231)
FROM jeanblanchard/alpine-glibc:3.7

LABEL maintainer="Ryo Ota <nwtgck@gmail.com>"

ENV GRAALVM_PATH=/usr/local/graalvm-ce
ENV PATH=$PATH:$GRAALVM_PATH/jre/languages/js/bin

# Copy only essential GraalVM files
COPY --from=graalvm_download /graalvm-ce/jre/languages/js/bin/node $GRAALVM_PATH/jre/languages/js/bin/node
COPY --from=graalvm_download /graalvm-ce/jre/lib/amd64/libjsig.so $GRAALVM_PATH/jre/lib/amd64/libjsig.so
COPY --from=graalvm_download /graalvm-ce/jre/lib/polyglot/libpolyglot.so $GRAALVM_PATH/jre/lib/polyglot/libpolyglot.so

# Copy bundled Piping Server
COPY --from=piping_bundle /piping-server/dist/index.js /app/index.js

ENTRYPOINT [ "node", "/app/index.js" ]
