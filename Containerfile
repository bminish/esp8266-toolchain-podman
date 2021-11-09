FROM debian:latest


MAINTAINER brendan minish <bminish@gmail.com>
# podman version 
#
# SDK github branch 
# Others may want to be on the 'master' branch
#ARG BRANCH=release/v3.4
ARG BRANCH=master

# xtensa toolchain version to download. Check for a new one from time to time. 29/6/2021
# see https://docs.espressif.com/projects/esp8266-rtos-sdk/en/latest/get-started/index.html
# ARG TOOLCHAIN_TARBALL_URL=https://dl.espressif.com/dl/xtensa-lx106-elf-gcc8_4_0-esp-2020r3-linux-amd64.tar.gz


# Prepare directory for tools
ARG TOOLS_PATH=/tools
RUN mkdir ${TOOLS_PATH}
WORKDIR ${TOOLS_PATH}

# Install basic programs and custom glibc
RUN apt-get update && apt-get install -y \
	bison cmake ccache dfu-util flex git gperf libffi-dev \ 
	libssl-dev libusb-1.0-0 ninja-build python3 python3-pip \ 
	python-is-python3 python3-setuptools python3-serial wget \


#	ca-certificates tar bzip2 wget make git gperf sed bash help2man libtool libtool-bin \
#	autoconf automake libtool gcc g++ flex bison texinfo gawk ncurses-dev \
#	cmake ninja-build ccache dfu-util libusbx \
#	libffi-dev libssl-dev python3 python-dev python3-setuptools python3-pip \
    && rm -rf /var/lib/apt/lists/*

# install ESP-IDF latest
ARG TOOLCHAIN_PATH=${TOOLS_PATH}/toolchain
RUN mkdir esp && cd esp \
	&& git clone --branch ${BRANCH} --recursive https://github.com/espressif/esp-idf.git 

# build it 
ARG TOOLCHAIN_PATH=${TOOLS_PATH}/toolchain
ENV PWD=/${TOOLS_PATH}/esp/esp-idf
RUN	cd /${TOOLS_PATH}/esp/esp-idf \
	&& ./install.sh esp32 
#	&& ./export.sh

## Install cmake 3.5
#ARG CMAKE_VERSION=3.5
#ARG CMAKE_BUILD=2
#ARG CMAKE_PATH=${TOOLS_PATH}/cmake-${CMAKE_VERSION}.${CMAKE_BUILD}-Linux-x86_64
#ARG CMAKE_INSTALLER_FILENAME=cmake-${CMAKE_VERSION}.${CMAKE_BUILD}-Linux-x86_64.sh
#RUN wget https://cmake.org/files/v${CMAKE_VERSION}/${CMAKE_INSTALLER_FILENAME}
#RUN chmod ugo+x ./${CMAKE_INSTALLER_FILENAME} \
#	&& echo "y" | ./${CMAKE_INSTALLER_FILENAME} --prefix=${TOOLS_PATH} \
#	&& rm ${CMAKE_INSTALLER_FILENAME}

#ENV PATH="${CMAKE_PATH}/bin:${PATH}"

#
## Install xtensa toolchain
#ARG TOOLCHAIN_PATH=${TOOLS_PATH}/toolchain
#RUN wget ${TOOLCHAIN_TARBALL_URL} \
#	&& export TOOLCHAIN_TARBALL_FILENAME=$(basename "${TOOLCHAIN_TARBALL_URL}") \
#	&& tar -xvf ${TOOLCHAIN_TARBALL_FILENAME}  \
#	&& mv `tar -tf ${TOOLCHAIN_TARBALL_FILENAME} | head -1` ${TOOLCHAIN_PATH} \
#	&& rm ${TOOLCHAIN_TARBALL_FILENAME}
#
#
## Install RTOS SDK
#ARG IDF_PATH=${TOOLS_PATH}/ESP8266_RTOS_SDK
## ARG MISSING_ESPTOOL_CMAKE_URL=https://raw.githubusercontent.com/espressif/esp-idf/master/components/esptool_py/run_esptool.cmake
#RUN git clone --branch ${BRANCH} https://github.com/espressif/ESP8266_RTOS_SDK.git \
#	&& python -m pip install pip==20.1 \
#	&& pip install --upgrade setuptools \
#	&& python -m pip install --user -r ${IDF_PATH}/requirements.txt 
##	&& wget -P ${IDF_PATH}/components/esptool_py ${MISSING_ESPTOOL_CMAKE_URL}
#
#WORKDIR /tools/ESP8266_RTOS_SDK/
#RUN git submodule init && git submodule update
#
ARG IDF_PATH=${TOOLS_PATH}/esp/esp-idf
ARG IDF_ADD_PATHS_EXTRAS="${IDF_PATH}/components/esptool_py/esptool"
ARG IDF_ADD_PATHS_EXTRAS="${IDF_ADD_PATHS_EXTRAS}:${IDF_PATH}/components/espcoredump"
ARG IDF_ADD_PATHS_EXTRAS="${IDF_ADD_PATHS_EXTRAS}:${IDF_PATH}/components/partition_table/"
ARG IDF_ADD_PATHS_EXTRAS="${IDF_ADD_PATHS_EXTRAS}:${IDF_PATH}/tools/"
ENV IDF_PATH="${IDF_PATH}"
#ENV PATH="${TOOLCHAIN_PATH}/bin:${PATH}"
ENV PATH="${IDF_PATH}/tools:${IDF_ADD_PATHS_EXTRAS}:${PATH}"
ENV PWD=/build
#
# Change workdir
WORKDIR /build
