#!/bin/bash

set -e

exec bash -c "varnishd -F -u varnish -f /etc/varnish/default.vcl -p default_ttl=3600 -p default_grace=3600"