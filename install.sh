#!/bin/bash

NAME=esp8266-toolchain
IMAGE_NAME=localhost/esp-sdk:latest
TOOLCHAIN_SCRIPT=${NAME}

#docker pull ${IMAGE_NAME}:latest

cat <<EOF > /tmp/${TOOLCHAIN_SCRIPT}.tmp
#!/bin/bash
while getopts ":p:" flag; do
        case "\${flag}" in
                p)
                        port=\${OPTARG}
                        shift 2
                        ;;
                esac
        done
if [ "\$port" = "" ]; then
        podman run --rm -it -v \$(pwd):/build localhost/esp-sdk:latest "\$@"
else
        podman run --rm -it --group-add=dialout --device \${port} -v \$(pwd):/build localhost/esp-sdk:latest "\$@"
fi


EOF

chmod ugo+x /tmp/${TOOLCHAIN_SCRIPT}.tmp
sudo mv /tmp/${TOOLCHAIN_SCRIPT}.tmp /usr/bin/${TOOLCHAIN_SCRIPT}
