# CUPS Docker Image

## docker-compose

```yaml
version: '2.4'
services:
  cups:
    image: xjasonlyu/cups:latest
    ports:
      - '631:631/tcp'
    volumes:
      - '/docker/cups:/etc/cups'
      - '/var/run/dbus:/var/run/dbus'
    restart: always
    privileged: true
    network_mode: bridge
    container_name: cups
```

## AirPlay

```sh
apt install avahi-daemon
systemctl enable avahi-daemon
systemctl restart avahi-daemon
```
