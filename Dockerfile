FROM ubuntu:16.04

LABEL maintainer="Ryo Ota <nwtgck@gmail.com>"

ENV GRAALVM_VERSION=1.0.0-rc13
ENV GRAALVM_PATH=/usr/local/graalvm-ce-$GRAALVM_VERSION
ENV PATH=$PATH:$GRAALVM_PATH/jre/languages/js/bin

RUN apt update && \
    apt install -y curl

# Download GraalVM and Install
RUN cd /usr/local && \
   curl -L https://github.com/oracle/graal/releases/download/vm-$GRAALVM_VERSION/graalvm-ce-$GRAALVM_VERSION-linux-amd64.tar.gz | tar zxf -

# NOTE: `! find` is for -delete option returning non 0 with errors "find: cannot delete"
RUN ! find $GRAALVM_PATH \
      ! -path $GRAALVM_PATH/jre/languages/js/bin/node \
      ! -path $GRAALVM_PATH/jre/lib/amd64/libjsig.so \
      ! -path $GRAALVM_PATH/jre/lib/polyglot/libpolyglot.so \
      -delete

ADD index.js /index.js

ENTRYPOINT [ "node", "index.js" ]
