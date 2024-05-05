# set-display-color

- Set the color of externerl HDMI display with DDC/CI according to time
- For Raspi Ubuntu desktop 21.10, require "kms" display driver. "fkms" is not supported
- With systemd timer and service, display parameter will be half hourly checked and updated

- You can tune some parameters for brightness, temperature and contrast in set-display-color script

## Install
```
$ sudo ./install.sh
```

## Uninstall
```
$ sudo ./uninstall.sh
```

## Show status
```
$ systemctl status set-display-color.timer
```

## Show detailed color status with DDC/CI
- Follwing is an example of DELL P3421W display

```
$ set-display-color show
VCP code 0x0b (Color temperature increment   ): 1 degree(s) Kelvin
VCP code 0x0c (Color temperature request     ): 3000 + 2 * (feature 0B color temp increment) degree(s) Kelvin
VCP code 0x10 (Brightness                    ): current value =    75, max value =   100
VCP code 0x12 (Contrast                      ): current value =    80, max value =   100
VCP code 0x14 (Select color preset           ): User 1 (sl=0x0b)
VCP code 0x16 (Video gain: Red               ): current value =   100, max value =   100
VCP code 0x18 (Video gain: Green             ): current value =    90, max value =   100
VCP code 0x1a (Video gain: Blue              ): current value =    80, max value =   100
VCP code 0x6c (Video black level: Red        ): current value =    50, max value =   255
VCP code 0x6e (Video black level: Green      ): current value =    50, max value =   255
VCP code 0x70 (Video black level: Blue       ): current value =    50, max value =   255
```

