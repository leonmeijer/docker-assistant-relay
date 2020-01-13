ARG ARCH=arm32v7
ARG NODE_VERSION=10
ARG OS=alpine

FROM ${ARCH}/node:${NODE_VERSION}-${OS}


# Install Build tools
RUN apk add --no-cache --virtual buildtools build-base linux-headers udev python && \
    npm install --unsafe-perm --no-update-notifier --no-audit --only=production && \
    /tmp/remove_native_gpio.sh && \
    cp -R node_modules prod_node_modules

LABEL maintainer "Kyle Lucy <kmlucy@gmail.com>"

RUN apk add --no-cache git tzdata && \
	git clone https://github.com/greghesp/assistant-relay.git && \
	cd assistant-relay && \
	git checkout master && \
	npm install && \
	apk del git

VOLUME /assistant-relay/server/configurations/secrets
VOLUME /assistant-relay/server/configurations/tokens
EXPOSE 3000

WORKDIR /assistant-relay
CMD npm run start
