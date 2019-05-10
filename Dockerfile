# NOTE: Multi-stage Build

FROM alpine:3.9 as graalvm_download

ENV GRAALVM_VERSION=19.0.0

RUN apk add --no-cache curl

# Download GraalVM and Install
RUN curl -L https://github.com/oracle/graal/releases/download/vm-${GRAALVM_VERSION}/graalvm-ce-linux-amd64-${GRAALVM_VERSION}.tar.gz | tar zxf - && \
    mv /graalvm-ce-$GRAALVM_VERSION /graalvm-ce



FROM node:10.15-alpine as piping_build

# Copy piping server to /app
COPY piping-server /app

# Build Piping Server
RUN cd /app && \
    npm install && \
    npm run build && \
    npm prune --production



# (base image info from: https://masahito.hatenablog.com/entry/2018/06/24/223231)
FROM jeanblanchard/alpine-glibc:3.9

LABEL maintainer="Ryo Ota <nwtgck@gmail.com>"

ENV GRAALVM_PATH=/usr/local/graalvm-ce
ENV PATH=$PATH:$GRAALVM_PATH/jre/languages/js/bin

# Install tini
RUN apk add --no-cache tini

# Copy only essential GraalVM files
COPY --from=graalvm_download /graalvm-ce/jre/languages/js/bin/node $GRAALVM_PATH/jre/languages/js/bin/node
COPY --from=graalvm_download /graalvm-ce/jre/lib/amd64/libjsig.so $GRAALVM_PATH/jre/lib/amd64/libjsig.so
COPY --from=graalvm_download /graalvm-ce/jre/lib/polyglot/libpolyglot.so $GRAALVM_PATH/jre/lib/polyglot/libpolyglot.so

# Copy Piping Server
COPY --from=piping_build /app /app

# Run a server
ENTRYPOINT [ "tini", "--", "node", "/app/dist/src/index.js" ]
