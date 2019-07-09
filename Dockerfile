# https://nodejs.org/en/download/
# Latest node.js LTS
# https://hub.docker.com/_/node?tab=tags
FROM node:10

# https://github.com/webpro/reveal-md/releases
ARG REVEAL_MD_VERSION=3.0.4
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
RUN npm install -g reveal-md@"$REVEAL_MD_VERSION"
EXPOSE 1948

# https://github.com/nodejs/docker-node/blob/master/docs/BestPractices.md#non-root-user
USER node
RUN mkdir -p /home/node/slides
WORKDIR /home/node/slides

COPY reveal.json ./
COPY ./01-what-is-cf ./01-what-is-cf
COPY ./02-interact-with-cf ./02-interact-with-cf
COPY ./03-first-app ./03-first-app
COPY ./04-buildpacks ./04-buildpacks
COPY ./05-resilience ./05-resilience
COPY ./06-debugging ./06-debugging
COPY ./07-shared-state ./07-shared-state
COPY ./08-domains-routes ./08-domains-routes

# Do not run as PID 1, delegate signals to /bin/sh:
# https://github.com/nodejs/docker-node/blob/master/docs/BestPractices.md#handling-kernel-signals
CMD reveal-md --host 0.0.0.0 --disable-auto-open
