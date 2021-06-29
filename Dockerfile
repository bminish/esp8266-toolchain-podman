FROM debian:jessie-slim

# original docker file 
#MAINTAINER Lukasz Marcin Podkalicki <lpodkalicki@gmail.com>
# https://blog.podkalicki.com/esp8266-dockerized-toolchain/
# https://hub.docker.com/r/lpodkalicki/esp8266-toolchain
# https://www.github.com/lpodkalicki/esp8266-toolchain-docker


MAINTAINER brendan minish <bminish@gmail.com>
# podman version 
# Note we are currenlty on branch 3.4 

# Prepare directory for tools
ARG TOOLS_PATH=/tools
RUN mkdir ${TOOLS_PATH}
WORKDIR ${TOOLS_PATH}

# Install basic programs and custom glibc
RUN apt-get update && apt-get install -y \
	ca-certificates tar bzip2 wget make git gperf sed bash help2man libtool libtool-bin \
	autoconf automake libtool gcc g++ flex bison texinfo gawk ncurses-dev \
	libffi-dev libssl-dev python python-dev python-setuptools python-pip vim

# Install cmake 3.5
ARG CMAKE_VERSION=3.5
ARG CMAKE_BUILD=2
ARG CMAKE_PATH=${TOOLS_PATH}/cmake-${CMAKE_VERSION}.${CMAKE_BUILD}-Linux-x86_64
ARG CMAKE_INSTALLER_FILENAME=cmake-${CMAKE_VERSION}.${CMAKE_BUILD}-Linux-x86_64.sh
RUN wget https://cmake.org/files/v${CMAKE_VERSION}/${CMAKE_INSTALLER_FILENAME}
RUN chmod ugo+x ./${CMAKE_INSTALLER_FILENAME} \
	&& echo "y" | ./${CMAKE_INSTALLER_FILENAME} --prefix=${TOOLS_PATH} \
	&& rm ${CMAKE_INSTALLER_FILENAME}

ENV PATH="${CMAKE_PATH}/bin:${PATH}"

# Install xtensa toolchain
ARG TOOLCHAIN_TARBALL_URL=https://dl.espressif.com/dl/xtensa-lx106-elf-gcc8_4_0-esp-2020r3-linux-amd64.tar.gz
ARG TOOLCHAIN_PATH=${TOOLS_PATH}/toolchain
RUN wget ${TOOLCHAIN_TARBALL_URL} \
	&& export TOOLCHAIN_TARBALL_FILENAME=$(basename "${TOOLCHAIN_TARBALL_URL}") \
	&& tar -xvf ${TOOLCHAIN_TARBALL_FILENAME}  \
	&& mv `tar -tf ${TOOLCHAIN_TARBALL_FILENAME} | head -1` ${TOOLCHAIN_PATH} \
	&& rm ${TOOLCHAIN_TARBALL_FILENAME}

ENV PATH="${TOOLCHAIN_PATH}/bin:${PATH}"

# Install RTOS SDK
ARG IDF_PATH=${TOOLS_PATH}/ESP8266_RTOS_SDK
# ARG MISSING_ESPTOOL_CMAKE_URL=https://raw.githubusercontent.com/espressif/esp-idf/master/components/esptool_py/run_esptool.cmake
RUN git clone --branch release/v3.4 https://github.com/espressif/ESP8266_RTOS_SDK.git \
	&& python -m pip install pip==20.1 \
	&& pip install --upgrade setuptools \
	&& python -m pip install --user -r ${IDF_PATH}/requirements.txt 
#	&& wget -P ${IDF_PATH}/components/esptool_py ${MISSING_ESPTOOL_CMAKE_URL}

WORKDIR /tools/ESP8266_RTOS_SDK/
RUN git submodule init && git submodule update

ENV PATH="${IDF_PATH}/tools:${PATH}"
ENV IDF_PATH=${IDF_PATH}
ENV PWD=/build

# Change workdir
WORKDIR /build
