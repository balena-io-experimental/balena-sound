#!/bin/bash

# blow up on non-zero exit code
set -e

# these are replaced by build.sh
PACKAGE_NAME=RoonBridge
ARCH=armv8
PACKAGE_URL=http://download.roonlabs.com/builds/RoonBridge_linuxarmv8.tar.bz2
PACKAGE_FILE=${PACKAGE_NAME}_linux${ARCH}.tar.bz2
PACKAGE_NAME_LOWER=`echo "$PACKAGE_NAME" | tr "[A-Z]" "[a-z]"`

TMPDIR=`mktemp -d`
MACHINE_ARCH=`uname -m`
OK=0

CLEAN_EXIT=0

# for colorization
ESC_SEQ="\033["
COL_RESET=$ESC_SEQ"39;49;00m"
COL_RED=$ESC_SEQ"31;01m"
COL_GREEN=$ESC_SEQ"32;01m"
COL_YELLOW=$ESC_SEQ"33;01m"
COL_BLUE=$ESC_SEQ"34;01m"
COL_MAGENTA=$ESC_SEQ"35;01m"
COL_CYAN=$ESC_SEQ"36;01m"
COL_BOLD=$ESC_SEQ"1m"

function hr {
    echo -e "${COL_BOLD}--------------------------------------------------------------------------------------${COL_RESET}"
}

function clean_up { 
    rm -Rf $TMPDIR
    if [ x$CLEAN_EXIT != x1 ]; then
        echo ""
        hr
        echo ""
        echo -e "${COL_BOLD}${COL_RED}The $PACKAGE_NAME installer did not complete successfully.${COL_RESET}"
        echo ""
        echo "If you are not sure how to proceed, please check out:"
        echo ""
        echo " - Roon Labs Community            https://community.roonlabs.com/c/support"
        echo " - Roon Labs Knowledge Base       https://kb.roonlabs.com/LinuxInstall"
        echo ""
        hr
        echo ""
    fi
}
trap clean_up EXIT

function install {
    #
    # Print banner/message
    #
    echo ""
    hr
    echo ""
    echo -e "${COL_BOLD}Welcome to the $PACKAGE_NAME installer${COL_RESET}"
    echo ""
    echo "This installer sets up $PACKAGE_NAME to run on linux with the following settings:" 
    echo ""
    echo " - $PACKAGE_NAME will be installed in /opt/$PACKAGE_NAME"
    echo " - $PACKAGE_NAME's data will be stored in /var/roon/$PACKAGE_NAME"
    echo " - $PACKAGE_NAME will be configured to run as a system service"
    echo " - $PACKAGE_NAME will run as root"
    echo ""
    echo "These settings are suitable for turning a dedicated or semi-dedicated device"
    echo "into an appliance that runs $PACKAGE_NAME"
    echo ""
    echo "If you want customize how $PACKAGE_NAME is installed, see:"
    echo ""
    echo "   http://kb.roonlabs.com/LinuxInstall"
    echo ""
    hr
    echo ""


    #
    # Check for linux (in case someone runs on OS X, Cygwin, BSD, etc)
    #
    case `uname -s` in 
        Linux)
            ;;
        *)
            echo -e "${COL_RED}${COL_BLOLD}Error:${COL_RESET} This package is intended for Linux platforms. It is not compatible with your machine. Exiting."
            ;;
    esac

    #
    # Check for proper architecture
    #
    case "$MACHINE_ARCH" in
        armv7*)
            if [ x$ARCH = xarmv7hf ]; then OK=1; fi
            ;;
        aarch64*)
            if [ x$ARCH = xarmv8 ]; then OK=1; fi
            if [ x$ARCH = xarmv7hf ]; then OK=1; fi
            ;;
        x86_64*)
            if [ x$ARCH = xx64 ]; then OK=1; fi 
            ;;
        i686*)
            if [ x$ARCH = xx86 ]; then OK=1; fi 
            ;;
    esac

    #
    # Check for root privileges
    #
    if [ x$UID != x0 ]; then
        echo ""
        echo -e "${COL_RED}${COL_BLOLD}Error:${COL_RESET} This installer must be run with root privileges. Exiting."
        echo ""
        exit 2
    fi

    #
    # Check for ffmpeg/avconv
    #

    if [ x$OK != x1 ]; then
        echo ""
        echo -e "${COL_RED}${COL_BLOLD}Error:${COL_RESET} This package is intended for $ARCH platforms. It is not compatible with your machine. Exiting."
        echo ""
        exit 3
    fi

    function confirm_n {
        while true; do
            read -p "$1 [y/N] " yn
            case $yn in
                [Yy]* ) 
                    break 
                    ;;
                "") 
                    CLEAN_EXIT=1
                    echo ""
                    echo "Ok. Exiting."
                    echo ""
                    exit 4 
                    ;;
                [Nn]* ) 
                    CLEAN_EXIT=1
                    echo ""
                    echo "Ok. Exiting."
                    echo ""
                    exit 4 
                    ;;
                * ) echo "Please answer yes or no.";;
            esac
        done
    }

    function confirm {
        while true; do
            read -p "$1 [Y/n] " yn
            case $yn in
                "") 
                    break 
                    ;;
                [Yy]* ) 
                    break 
                    ;;
                [Nn]* ) 
                    CLEAN_EXIT=1
                    echo ""
                    echo "Ok. Exiting."
                    echo ""
                    exit 4 
                    ;;
                * ) echo "Please answer yes or no.";;
            esac
        done
    }

    #
    # Double-check with user that this is what they want
    #
    confirm "Do you want to install $PACKAGE_NAME on this machine?"

    echo ""
    echo "Downloading $PACKAGE_FILE to $TMPDIR/$PACKAGE_FILE"
    echo ""
    curl -# -o "$TMPDIR/$PACKAGE_FILE" "$PACKAGE_URL"

    echo ""
    echo -n "Unpacking ${PACKAGE_FILE}..."
    cd $TMPDIR
    tar xf "$PACKAGE_FILE"
    echo "Done"

    if [ ! -d "$TMPDIR/$PACKAGE_NAME" ]; then 
        echo "Missing directory: $TMPDIR/$PACKAGE_NAME. This indicates a broken package."
        exit 5
    fi

    if [ ! -f "$TMPDIR/$PACKAGE_NAME/check.sh" ]; then 
        echo "Missing $TMPDIR/$PACKAGE_NAME/check.sh. This indicates a broken package."
        exit 5
    fi

    $TMPDIR/$PACKAGE_NAME/check.sh

    if [ -e /opt/$PACKAGE_NAME ]; then
        hr
        echo ""
        echo -e "${COL_RED}${COL_BOLD}Warning:${COL_RESET} The /opt/$PACKAGE_NAME directory already exists."
        echo ""
        echo "This usually indicates that $PACKAGE_NAME was installed previously on this machine. The previous"
        echo "installation must be deleted before the installation can proceed."
        echo ""
        echo "Under normal circumstances, this directory does not contain any user data, so it should be safe to delete it."
        echo ""
        hr
        echo ""
        confirm "Delete /opt/$PACKAGE_NAME and re-install?"
        rm -Rf /opt/$PACKAGE_NAME
    fi

    echo ""
    echo -n "Copying Files..."
    mv "$TMPDIR/$PACKAGE_NAME" /opt
    echo "Done"

    # set up systemd 
    HAS_SYSTEMCTL=1; which systemctl >/dev/null || HAS_SYSTEMCTL=0

    if [ $HAS_SYSTEMCTL = 1 -a -d /etc/systemd/system ]; then
        SERVICE_FILE=/etc/systemd/system/${PACKAGE_NAME_LOWER}.service

        # stop in case it's running from an old install
        systemctl stop $PACKAGE_NAME_LOWER || true

        echo ""
        echo "Installing $SERVICE_FILE"

        cat > $SERVICE_FILE << END_SYSTEMD
[Unit]
Description=$PACKAGE_NAME
After=network-online.target

[Service]
Type=simple
User=root
Environment=ROON_DATAROOT=/var/roon
Environment=ROON_ID_DIR=/var/roon
ExecStart=/opt/$PACKAGE_NAME/start.sh
Restart=on-abort

[Install]
WantedBy=multi-user.target
END_SYSTEMD

        echo ""
        echo "Enabling service ${PACKAGE_NAME_LOWER}..."
        systemctl enable ${PACKAGE_NAME_LOWER}.service
        echo "Service Enabled"

        echo ""
        echo "Starting service ${PACKAGE_NAME_LOWER}..."
        systemctl start ${PACKAGE_NAME_LOWER}.service
        echo "Service Started"
    else
        echo ""

        SERVICE_FILE=/etc/init.d/${PACKAGE_NAME_LOWER}

        /etc/init.d/$PACKAGE_NAME_LOWER stop || true

        cat > $SERVICE_FILE << END_LSB_INIT
#!/bin/sh

### BEGIN INIT INFO
# Provides:          ${PACKAGE_NAME_LOWER}
# Required-Start:    \$network
# Required-Stop:     \$network
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Runs ${PACKAGE_NAME}
### END INIT INFO

# Defaults
DAEMON_NAME="$PACKAGE_NAME"
DAEMON_EXECUTABLE="/opt/$PACKAGE_NAME/start.sh"
DAEMON_OPTIONS=""
DAEMON_HOMEDIR="/opt/$PACKAGE_NAME"
DAEMON_PIDFILE="/var/run/${PACKAGE_NAME_LOWER}.pid"
DAEMON_LOGFILE="/var/log/${PACKAGE_NAME_LOWER}.log"
INIT_SLEEPTIME="2"

export ROON_DATAROOT=/var/roon
export ROON_ID_DIR=/var/roon

PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin

if test -f /lib/lsb/init-functions; then
    . /lib/lsb/init-functions
fi
if test -f /etc/init.d/functions; then
    . /etc/init.d/functions
fi

### DO NOT EDIT BELOW THIS POINT ###

is_running () {
    # Test whether pid file exists or not
    test -f \$DAEMON_PIDFILE || return 1

    # Test whether process is running or not
    read PID < "\$DAEMON_PIDFILE"
    ps -p \$PID >/dev/null 2>&1 || return 1

    # Is running
    return 0
}

root_only () {
    if [ "\$(id -u)" != "0" ]; then
        echo "Only root should run this operation"
        exit 1
    fi
}

run () {
    if is_running; then
        PID="\$(cat \$DAEMON_PIDFILE)"
        echo "Daemon is already running as PID \$PID"
        return 1
    fi

    cd \$DAEMON_HOMEDIR

    nohup \$DAEMON_EXECUTABLE \$DAEMON_OPTIONS >>\$DAEMON_LOGFILE 2>&1 &
    echo \$! > \$DAEMON_PIDFILE
    read PID < "\$DAEMON_PIDFILE"

    sleep \$INIT_SLEEPTIME
    if ! is_running; then
        echo "Daemon died immediately after starting. Please check your logs and configurations."
        return 1
    fi

    echo "Daemon is running as PID \$PID"
    return 0
}

stop () {
    if is_running; then
        read PID < "\$DAEMON_PIDFILE"
        kill \$PID
    fi
    sleep \$INIT_SLEEPTIME
    if is_running; then
        while is_running; do
            echo "waiting for daemon to die (PID \$PID)"
            sleep \$INIT_SLEEPTIME
        done
    fi
    rm -f "\$DAEMON_PIDFILE"
    return 0
}

case "\$1" in
    start)
        root_only
        log_daemon_msg "Starting \$DAEMON_NAME"
        run
        log_end_msg \$?
        ;;
    stop)
        root_only
        log_daemon_msg "Stopping \$DAEMON_NAME"
        stop
        log_end_msg \$?
        ;;
    restart)
        root_only
        \$0 stop && \$0 start
        ;;
    status)
        status_of_proc \
            -p "\$DAEMON_PIDFILE" \
            "\$DAEMON_EXECUTABLE" \
            "\$DAEMON_NAME" \
            && exit 0 \
            || exit \$?
        ;;
    *)
        echo "Usage: \$0 {start|stop|restart|status}"
        exit 1
        ;;
esac
END_LSB_INIT

        echo "wrote out file"
        chmod +x ${SERVICE_FILE}

        HAS_UPDATE_RC_D=1; which update-rc.d >/dev/null || HAS_UPDATE_RC_D=0
        HAS_CHKCONFIG=1; which chkconfig >/dev/null || HAS_CHKCONFIG=0

        if [ $HAS_UPDATE_RC_D = 1 ]; then
            echo ""
            echo "Enabling service ${PACKAGE_NAME_LOWER} using update-rc.d..."
            update-rc.d ${PACKAGE_NAME_LOWER} defaults
            echo "Service Enabled"
        elif [ $HAS_CHKCONFIG = 1 ]; then
            echo ""
            echo "Enabling service ${PACKAGE_NAME_LOWER} using chkconfig..."
            chkconfig --add ${PACKAGE_NAME_LOWER}
            echo "Service Enabled"
        else
            echo "Couldn't find a way to enable the init script"
            exit 1
        fi

        echo ""
        echo "Starting service ${PACKAGE_NAME_LOWER}..."
        $SERVICE_FILE stop >/dev/null 2>&1 || true
        $SERVICE_FILE start
        echo "Service Started"

        echo "Setting up $PACKAGE_NAME to run at boot using LSB scripts"
    fi

    CLEAN_EXIT=1

    echo ""
    hr
    echo ""
    echo "All Done! $PACKAGE_NAME should be running on your machine now".
    echo ""
    hr
    echo ""
}

function uninstall {
    #
    # Print banner/message
    #
    echo ""
    hr
    echo ""
    echo -e "${COL_BOLD}Welcome to the $PACKAGE_NAME uninstaller${COL_RESET}"
    echo ""
    echo "This removes $PACKAGE_NAME from your machine by doing the following:"
    echo ""
    echo " - deleting all files in /opt/$PACKAGE_NAME"
    echo " - removing $PACKAGE_NAME as a system service"
    echo ""
    echo "This uninstaller is only for systems that were installed using this installer script." 
    echo "If you performed a custom install by hand, this is not for you."
    echo ""
    echo "   http://kb.roonlabs.com/LinuxInstall"
    echo ""
    hr
    echo ""


    #
    # Check for linux (in case someone runs on OS X, Cygwin, BSD, etc)
    #
    case `uname -s` in 
        Linux)
            ;;
        *)
            echo -e "${COL_RED}${COL_BLOLD}Error:${COL_RESET} This package is intended for Linux platforms. It is not compatible with your machine. Exiting."
            ;;
    esac

    #
    # Check for proper architecture
    #
    case "$MACHINE_ARCH" in
        armv7*)
            if [ x$ARCH = xarmv7hf ]; then OK=1; fi
            ;;
        aarch64*)
            if [ x$ARCH = xarmv8 ]; then OK=1; fi
            if [ x$ARCH = xarmv7hf ]; then OK=1; fi
            ;;
        x86_64*)
            if [ x$ARCH = xx64 ]; then OK=1; fi 
            ;;
        i686*)
            if [ x$ARCH = xx86 ]; then OK=1; fi 
            ;;
    esac

    #
    # Check for root privileges
    #
    if [ x$UID != x0 ]; then
        echo ""
        echo -e "${COL_RED}${COL_BLOLD}Error:${COL_RESET} This installer must be run with root privileges. Exiting."
        echo ""
        exit 2
    fi

    if [ x$OK != x1 ]; then
        echo ""
        echo -e "${COL_RED}${COL_BLOLD}Error:${COL_RESET} This package is intended for $ARCH platforms. It is not compatible with your machine. Exiting."
        echo ""
        exit 3
    fi

    function confirm_n {
        while true; do
            read -p "$1 [y/N] " yn
            case $yn in
                [Yy]* ) 
                    break 
                    ;;
                "") 
                    CLEAN_EXIT=1
                    echo ""
                    echo "Ok. Exiting."
                    echo ""
                    exit 4 
                    ;;
                [Nn]* ) 
                    CLEAN_EXIT=1
                    echo ""
                    echo "Ok. Exiting."
                    echo ""
                    exit 4 
                    ;;
                * ) echo "Please answer yes or no.";;
            esac
        done
    }

    function confirm {
        while true; do
            read -p "$1 [Y/n] " yn
            case $yn in
                "") 
                    break 
                    ;;
                [Yy]* ) 
                    break 
                    ;;
                [Nn]* ) 
                    CLEAN_EXIT=1
                    echo ""
                    echo "Ok. Exiting."
                    echo ""
                    exit 4 
                    ;;
                * ) echo "Please answer yes or no.";;
            esac
        done
    }

    #
    # Double-check with user that this is what they want
    #
    confirm_n "Are you sure that you want to uninstall $PACKAGE_NAME on this machine?"

    # set up systemd 
    HAS_SYSTEMCTL=1; which systemctl >/dev/null || HAS_SYSTEMCTL=0

    if [ $HAS_SYSTEMCTL = 1 -a -d /etc/systemd/system ]; then
        SERVICE_FILE=/etc/systemd/system/${PACKAGE_NAME_LOWER}.service

        echo ""
        echo "Stopping service $PACKAGE_NAME_LOWER"
        systemctl stop $PACKAGE_NAME_LOWER || true
        echo "Service Stopped"

        echo ""
        echo "Disabling service ${PACKAGE_NAME_LOWER}..."
        systemctl disable ${PACKAGE_NAME_LOWER}.service || true
        echo "Service Disabled"

        echo ""
        echo "Removing service file $SERVICE_FILE"
        rm -f $SERVICE_FILE

    else
        SERVICE_FILE=/etc/init.d/${PACKAGE_NAME_LOWER}

        echo ""
        echo "Stopping service ${PACKAGE_NAME_LOWER}..."
        $SERVICE_FILE stop >/dev/null 2>&1 || true
        echo "Service Stopped"

        echo ""
        echo "Removing service ${PACKAGE_NAME_LOWER}..."
        if [ $HAS_UPDATE_RC_D = 1 ]; then
            echo ""
            echo "Disabling service ${PACKAGE_NAME_LOWER} using update-rc.d..."
            update-rc.d ${PACKAGE_NAME_LOWER} remove
            echo "Service Disabled"
        elif [ $HAS_CHKCONFIG = 1 ]; then
            echo ""
            echo "Disabling service ${PACKAGE_NAME_LOWER} using chkconfig..."
            chkconfig --del ${PACKAGE_NAME_LOWER}
            echo "Service Disabled"
        else
            echo "Couldn't find a way to disable the init script"
            exit 0
        fi
        echo "Service Removed"

        echo ""
        echo "Removing service file $SERVICE_FILE"
        rm -f $SERVICE_FILE
    fi

    echo ""
    echo -n "Deleting all files in /opt/$PACKAGE_NAME"
    rm -Rf /opt/$PACKAGE_NAME

    CLEAN_EXIT=1

    echo ""
    hr
    echo ""
    echo "All Done! $PACKAGE_NAME should be uninstalled."
    echo ""
    hr
    echo ""
}


if [ x$1 == xuninstall ]; then
    uninstall
else 
    install
fi
