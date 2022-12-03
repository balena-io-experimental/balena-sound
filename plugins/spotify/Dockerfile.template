FROM andrewn/librespot:0.4.2-pulseaudio

ENV PULSE_SERVER=tcp:localhost:4317

COPY start.sh /usr/src/

CMD [ "/bin/bash", "/usr/src/start.sh" ]
