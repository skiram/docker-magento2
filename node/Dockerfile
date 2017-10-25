FROM node:6

RUN npm install -g gulp-cli

RUN useradd docker \
    && mkdir -p /home/docker/app \
    && chown -R docker:docker /home/docker

WORKDIR /home/docker/app
