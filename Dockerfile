# (base image info from: https://masahito.hatenablog.com/entry/2018/06/24/223231)
FROM jeanblanchard/alpine-glibc:3.7

LABEL maintainer="Ryo Ota <nwtgck@gmail.com>"

ENV GRAALVM_VERSION=1.0.0-rc13
ENV GRAALVM_PATH=/usr/local/graalvm-ce-$GRAALVM_VERSION
ENV PATH=$PATH:$GRAALVM_PATH/jre/languages/js/bin

RUN apk add --no-cache curl

# Download GraalVM and Install
RUN cd /usr/local && \
   curl -L https://github.com/oracle/graal/releases/download/vm-$GRAALVM_VERSION/graalvm-ce-$GRAALVM_VERSION-linux-amd64.tar.gz | tar zxf -

# Leave only essential files
RUN find $GRAALVM_PATH \
      ! -path $GRAALVM_PATH/jre/languages/js/bin/node \
      ! -path $GRAALVM_PATH/jre/lib/amd64/libjsig.so \
      ! -path $GRAALVM_PATH/jre/lib/polyglot/libpolyglot.so \
      -delete

ADD index.js /index.js

ENTRYPOINT [ "node", "index.js" ]
