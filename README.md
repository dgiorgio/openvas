# New Project: https://github.com/dgiorgio/gvm-docker
# [DEPRECATED] OpenVAS Container for Docker - based on rpm packages by Atomicorp.

## Quick start

```
$ docker volume create openvas_data
$ docker run -d --name openvas --restart always \
  -p 80:80 -p 443:443 -p 9390-9392:9390-9392 \
  -v openvas_data:/var/lib/openvas/ \
   dgiorgio/openvas
```
#### Update

```
$ docker exec openvas update-NVT
```

Full update and check (if necessary):

```
$ docker exec openvas update-NVT full
```

## Custom scripts

Before: `bin/script-custom-before.sh` - `/usr/local/bin/script-custom-before.sh`

After: `bin/script-custom-after.sh` - `/usr/local/bin/script-custom-after.sh`

```
$ docker run -d --name openvas --restart always \
  -p 80:80 -p 443:443 -p 9390-9392:9390-9392 \
  -v openvas_data:/var/lib/openvas/ \
  -v "~/script-custom-before.sh:/usr/local/bin/script-custom-before.sh" \
  -v "~/myscript.sh:/usr/local/bin/script-custom-after.sh" \
   dgiorgio/openvas
```

## Compose

```
version: '3'
services:
  openvas:
    image: dgiorgio/openvas
    hostname: "openvas"
    restart: always
    ports:
      - "80:80"
      - "443:443"
      - "9390-9392:9390-9392"
    volumes:
      - "data:/var/lib/openvas/"
      - "/etc/localtime:/etc/localtime:ro"
    labels:
      deck-chores.dump.command: sh -c "update-NVT"
      deck-chores.dump.cron: 0 23 * * *
      
  cron:
    image: funkyfuture/deck-chores
    restart: always
    environment:
      TIMEZONE: America/Sao_Paulo
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"
      - "/etc/localtime:/etc/localtime:ro"
      
volumes:
  data:
```

## License

This Docker image is licensed under the BSD, see [LICENSE](LICENSE.md).

