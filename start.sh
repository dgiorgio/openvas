#!/usr/bin/env bash

set -euo pipefail

PROJECT="openvas"

DOCKERFILE="Dockerfile"
#DOCKERFILE="Dockerfile.alpine" #TEST


docker build --compress -t "${PROJECT}" -f "${DOCKERFILE}" .

##### 1
# docker volume create openvas_data
# docker run -ti \
# -v /etc/localtime:/etc/localtime:ro \
# -v openvas_data:/var/lib/openvas/ \
# -p "443:443" \
# -p "80:80" \
# -p "9390-9392:9390-9392" \
# --name openvas \
# dgiorgio/openvas

##### 2
# docker volume create openvas_mgr 
# docker volume create openvas_plugins 
# docker volume create openvas_cert
# docker volume create openvas_scap
# docker run -ti \
# -v openvas_mgr:/var/lib/openvas/mgr \
# -v openvas_plugins:/var/lib/openvas/plugins \
# -v openvas_cert:/var/lib/openvas/cert-data \
# -v openvas_scap:/var/lib/openvas/scap-data \
# -p "443:443" \
# -p "80:80" \
# -p "9390-9392:9390-9392" \
# --name openvas \
# dgiorgio/openvas



