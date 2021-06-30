#!/bin/bash

NAME=esp8266-toolchain
IMAGE_NAME=localhost/esp-sdk:latest
TOOLCHAIN_SCRIPT=${NAME}

#docker pull ${IMAGE_NAME}:latest

cat <<EOF > /tmp/${TOOLCHAIN_SCRIPT}.tmp
#!/bin/bash

podman run --rm -it -v \$(pwd):/build ${IMAGE_NAME} "\$@"
EOF

chmod ugo+x /tmp/${TOOLCHAIN_SCRIPT}.tmp
sudo mv /tmp/${TOOLCHAIN_SCRIPT}.tmp /usr/bin/${TOOLCHAIN_SCRIPT}
