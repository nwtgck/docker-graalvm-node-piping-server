# docker-graalvm-node-piping-server
[![CircleCI](https://circleci.com/gh/nwtgck/docker-graalvm-node-piping-server.svg?style=shield)](https://circleci.com/gh/nwtgck/docker-graalvm-node-piping-server) [![](https://images.microbadger.com/badges/image/nwtgck/graalvm-node-piping-server.svg)](https://microbadger.com/images/nwtgck/graalvm-node-piping-server "Get your own image badge on microbadger.com")

Docker image for [Piping Server](https://github.com/nwtgck/piping-server) on [Node.js](https://nodejs.org) on [GraalVM](https://www.graalvm.org/)

## Run on Docker

```bash
docker run -it -p 8181:8080 nwtgck/graalvm-node-piping-server
```

Then, a Piping server is running on http://localhost:8181.
