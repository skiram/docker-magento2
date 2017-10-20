FROM debian:jessie

RUN apt-get update

RUN apt-get install -y varnish

EXPOSE 80

COPY default.vcl /etc/varnish/default.vcl
COPY docker-environment /usr/local/bin/docker-environment
COPY start.sh /start.sh

ENV BACKEND_HOST nginx
ENV BACKEND_PORT 80
ENV ACL_PURGE fpm

ENTRYPOINT ["/usr/local/bin/docker-environment"]
CMD ["/start.sh"]
