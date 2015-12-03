#!/bin/sh

set -eo pipefail

LBIP=$1
ETCDIP=$2

if [[ -z "$LBIP" ]]; then
  echo "$0 <LB IP> <ETCD IP>"
  exit 1
fi

if [[ -z "$ETCDIP" ]]; then
  echo "$0 <LB IP> <ETCD IP>"
  exit 1
fi

ssh root@$LBIP << EOF
  apt-get update
  apt-get install haproxy
  mkdir -p /etc/confd/conf.d
  mkdir -p /etc/confd/templates
  cd /root
  wget https://github.com/kelseyhightower/confd/releases/download/v0.11.0/confd-linux-amd64
  mv confd-linux-amd64 /usr/local/bin/confd
  chmod 755 /usr/local/bin/confd
EOF

scp haproxy.cfg.tmpl root@$1:/etc/confd/templates
scp haproxy.toml root@$1:/etc/confd/conf.d
scp confd.toml root@$1:/etc/confd

ssh root@$LBIP << EOF
  sed -i "s/ETCDNODE/$ETCDIP/" /etc/confd/confd.toml
EOF
