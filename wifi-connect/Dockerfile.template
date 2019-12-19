FROM balenalib/raspberrypi3

ENV INITSYSTEM on

RUN install_packages dnsmasq wireless-tools wget

WORKDIR /usr/src/app

RUN curl https://api.github.com/repos/balena-io/wifi-connect/releases/latest -s \
    | grep -hoP 'browser_download_url": "\K.*%%BALENA_ARCH%%\.tar\.gz' \
    | xargs -n1 curl -Ls \
    | tar -xvz -C /usr/src/app/

COPY ./start.sh .

CMD ["bash", "start.sh"]
