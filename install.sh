#!/bin/bash -eu

NAME=set-display-color
BIN=/usr/local/bin/$NAME

if [ $# -eq 1 ] && [ $1 = "uninstall" ]; then
  [ $(id -u) -eq 0 ] || { echo "You must root"; exit 1; }
  systemctl stop $NAME.timer
  systemctl disable $NAME.timer
  rm -f $BIN /etc/systemd/system/$NAME.{timer,service}
  exit

elif [ $# -eq 1 ] && [ $1 = "status" ]; then
  systemctl status $NAME.timer
  exit

else ### install
  [ $(id -u) -eq 0 ] || { echo "You must root"; exit 1; }
  cp -i $NAME $BIN
  chmod u+x $BIN

  cp $NAME.{timer,service} /etc/systemd/system
  systemctl daemon-reload
  systemctl enable $NAME.timer
  systemctl start $NAME.timer

  echo done
fi
