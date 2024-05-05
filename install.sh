#!/bin/bash -eu

NAME=set-display-color
BIN=/usr/local/bin/$NAME

isRoot() { [ $(id -u) -ne 0 ] || return 0; echo "You must root" >&2; exit 1; }
systemctlAsUser() {
  # Required XDG_RUNTIME_DIR env in GNOME environment
  sudo -u $SUDO_USER XDG_RUNTIME_DIR=/run/user/$(id -u $SUDO_USER) \
    systemctl --user --now $1 $NAME.timer
}

dpkg --no-pager -l ddcutil >/dev/null 2>&1 || {
  isRoot
  echo -n "install ddcutil package ... "
  apt install ddcutil
  echo done
}

(id -Gn  | grep -w i2c >/dev/null 2>&1) || {
  isRoot
  echo -n "add user '$USER' to i2c group ... "
  usermod -G i2c -a $USER
  echo done
}

if [ $# -eq 1 ] && [ $1 = "uninstall" ]; then
  isRoot
  echo -n "stop systemd $NAME.timer ... "
  systemctlAsUser disable
  echo done
  echo -n "remove files ... "
  rm -f $BIN /lib/systemd/user/$NAME.{timer,service} $BIN
  echo done
  exit

elif [ $# -eq 1 ] && [ $1 = "status" ]; then
  [ "$USER" = "root" ] || {
    systemctl --user status $NAME.timer
  } && {
    systemctlAsUser status
  }
  exit

else ### install
  isRoot
  [ -x "$BIN" ] || {
    echo -n "install $BIN ... "
    cp -i $NAME $BIN
    chmod u+x $BIN
    echo done
  }
  [ -f /lib/systemd/user/$NAME.service ] || {
    echo -n "install systemd files ... "
    cp $NAME.{timer,service} /lib/systemd/user
    echo done
  }

  echo -n "enable and start systemd timer ... "
  systemctl daemon-reload
  systemctlAsUser enable
  echo done
fi
