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

## AirPrint Support

Install `avahi-daemon` service

```sh
apt install -y avahi-daemon
systemctl enable avahi-daemon
systemctl restart avahi-daemon
```

## Restart CUPS when USB plug in

> My printer: Samsung ML-1670 Series

List USB devices

```sh
$ lsusb
Bus 001 Device 005: ID 04e8:3313 Samsung Electronics Co., Ltd
Bus 001 Device 003: ID 0424:ec00 Microchip Technology, Inc. (formerly SMSC) SMSC9512/9514 Fast Ethernet Adapter
Bus 001 Device 002: ID 0424:9514 Microchip Technology, Inc. (formerly SMSC) SMC9514 Hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
```

Check details

```sh
$ udevadm info -a -p $(udevadm info -q path -n /dev/bus/usb/001/005)
looking at device '/devices/platform/soc/3f980000.usb/usb1/1-1/1-1.2':
  KERNEL=="1-1.2"
  SUBSYSTEM=="usb"
  DRIVER=="usb"
  ATTR{serial}=="xxxxxxx"
  ATTR{removable}=="removable"
  ATTR{idVendor}=="04e8"
  ATTR{devspec}=="(null)"
  ATTR{speed}=="480"
  ATTR{manufacturer}=="Samsung Electronics Co., Ltd."
  ATTR{version}==" 2.00"
  ATTR{bMaxPacketSize0}=="64"
  ATTR{bmAttributes}=="c0"
  ATTR{configuration}==""
  ATTR{idProduct}=="3313"
  ATTR{bDeviceProtocol}=="00"
  ATTR{product}=="ML-1670 Series"
  ATTR{busnum}=="1"
  ATTR{tx_lanes}=="1"
  ATTR{bDeviceClass}=="00"
  ATTR{ltm_capable}=="no"
  ATTR{devnum}=="5"
  ATTR{rx_lanes}=="1"
  ATTR{authorized}=="1"
  ATTR{bMaxPower}=="2mA"
  ATTR{quirks}=="0x0"
  ATTR{avoid_reset_quirk}=="0"
  ATTR{bNumConfigurations}=="1"
  ATTR{bcdDevice}=="0100"
  ATTR{devpath}=="1.2"
  ATTR{bConfigurationValue}=="1"
  ATTR{bDeviceSubClass}=="00"
  ATTR{urbnum}=="160"
  ATTR{bNumInterfaces}==" 1"
  ATTR{maxchild}=="0"
```

Creating a new file in `/etc/udev/rules.d/`

```sh
vim /etc/udev/rules.d/10-reload.cups.rules
```

Put following line in that file

```sh
ACTION=="add", SUBSYSTEM=="usb", ATTRS{product}=="ML-1670 Series", RUN+="/bin/sh -c 'docker ps -f name=cups | grep cups && docker restart cups'"
```

Reload udev rules

```sh
udevadm control --reload-rules
```
