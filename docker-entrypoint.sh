#!/usr/bin/env bash

/usr/local/bin/script-custom-before.sh

redis-server /etc/redis.conf --daemonize yes

_REDIS-CHECK() {
  REDIS_RESULT="$(redis-cli ping)"
}

echo "Testing redis status..."
_REDIS-CHECK

while  [ "${REDIS_RESULT}" != "PONG" ]; do
  echo "Redis not yet ready..."
  sleep 1
  _REDIS-CHECK
done
echo "Redis ready."

/usr/local/bin/openvas-setup

echo
echo "Openvas Setup"
echo 

echo "openvas-scanner - creating cache..."
openvassd -C >/dev/null 2>&1
echo "openvas-scanner- starting..."
openvassd >/dev/null 2>&1 
echo -n "Pausing while openvas-scanner loads NVTs..."
sleep 10
echo "Done"

if [ -f /var/lib/openvas/mgr/tasks.db ]; then
  echo "openvas-manager - migrating..."
  openvasmd --migrate --progress 
else
  echo "openvas-manager - rebuilding..."
  openvasmd --rebuild --progress 
fi

echo "Starting openvas-manager..."
openvasmd >/dev/null 2>&1

gsad

/usr/local/bin/script-custom-after.sh

while true; do
  echo "Tailing logs"
  tail -F /var/log/openvas/*
done
