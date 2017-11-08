#!/bin/bash

set -e

exec bash -c "varnishd -a :$LISTEN_PORT -F -u varnish -f /etc/varnish/default.vcl -p default_ttl=3600 -p default_grace=3600"