FROM balenalib/%%BALENA_MACHINE_NAME%%-debian:stretch-run

# Install XORG
RUN install_packages xserver-xorg=1:7.7+19 \
  xserver-xorg-input-evdev \
  xinit \
  xfce4 \
  xfce4-terminal \
  x11-xserver-utils \
  dbus-x11 \
  matchbox-keyboard \
  xterm


# Disable screen from turning it off
RUN echo "#!/bin/bash" > /etc/X11/xinit/xserverrc \
  && echo "" >> /etc/X11/xinit/xserverrc \
  && echo 'exec /usr/bin/X -s 0 dpms' >> /etc/X11/xinit/xserverrc 

# Setting working directory
WORKDIR /usr/src/app

COPY . ./

ENV UDEV=1

# Avoid requesting XFCE4 question on X start
ENV XFCE_PANEL_MIGRATE_DEFAULT=1

CMD ["bash", "start_x86.sh"]