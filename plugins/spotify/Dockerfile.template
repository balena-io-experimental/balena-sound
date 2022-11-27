FROM tmigone/librespot:0.3.1-pulseaudio

ENV PULSE_SERVER=tcp:localhost:4317

COPY start.sh /usr/src/

CMD [ "/bin/bash", "/usr/src/start.sh" ]