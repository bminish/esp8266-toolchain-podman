
# Overview

Lightweight  podman image built on top of **debian:jessie-slim** with installed xtensa toolchain, ESP8266_RTOS_SDK and few additional tools:
* xtensa-lx106 (xtensa-lx106-elf-gcc8_4_0-esp-2020r3-linux-amd64.tar.gz)
* ESP8266_RTOS_SDK (v3.4)
* esptool.py (v2.4)
* make (v4.2)
* cmake (v3.5)

Original dockerfile: https://github.com/lpodkalicki/esp8266-toolchain-docker

## Building and installing image locally

```bash
git clone 
cd eps8266-toolchain
 ./build.sh 
 ./install.sh
```

## An example of running toolchain binary

```bash
podman run --rm -it --privileged -v $(pwd):/build localhost/esp-sdk xtensa-lx106-elf-gcc --version
```

## Getting started

1. build and install.
2. Use super command **esp8266-toolchain** for all toolchain binaries. 
3. Execute toolchain binaries inside your working/project directory. 

## Examples

```bash
$ cd your-project/
$ esp8266-toolchain idf.py build
$ esp8266-toolchain idf.py flash
$ esp8266-toolchain idf.py monitor
$ esp8266-toolchain xtensa-lx106-elf-gcc --version
$ esp8266-toolchain make -version
$ esp8266-toolchain cmake -version
$ esp8266-toolchain make menuconfig
$ esp8266-toolchain make && make flash monitor
```

# esp8266-toolchain-podman
