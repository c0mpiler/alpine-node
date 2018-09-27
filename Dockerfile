FROM node:alpine

LABEL authors="Harsha Krishnareddy"

#Linux setup
RUN apk update \
  && apk add --update alpine-sdk \
  && apk del alpine-sdk \
  && rm -rf /tmp/* /var/cache/apk/* *.tar.gz ~/.npm \
  && npm cache verify \
  && sed -i -e "s/bin\/ash/bin\/sh/" /etc/passwd

# install angular-cli as node user
RUN chown -R node:node /usr/local/lib/node_modules \
  && chown -R node:node /usr/local/bin

USER node

#Angular CLI
RUN npm install -g @angular/cli@latest

# set npm as default package manager for root
USER root
RUN ng set --global packageManager=npm

# install chromium for headless browser tests
ENV CHROME_BIN=/usr/bin/chromium-browser
RUN apk add --no-cache chromium udev ttf-freefont

RUN apk add --no-cache \
			build-base \
			ca-certificates \
			bash \
			gcc
			
RUN apk add git			

CMD ["/bin/ash"]
