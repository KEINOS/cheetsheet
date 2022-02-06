[INDEX](../)

---

# RaspberryPi CheetSheet

This is a memorandum for KEINOS.

## RaspberryPi Imager

### Advanced Mode

- `ctrl` + `shift` + `x`: To setup SSH, WiFi, Country Code, Timezone, etc.

## How to check the voltage status

```bash
vcgencmd get_throttled
```

| Hex Value | Description |
| :--: | :--- |
| `0x0` | No problem. |
| `0x50000` | No problem now, but the electrical voltage has been low for a while.|
| `0x50005` | Currently the electrical voltage is low. |
| `0x80000` | Due to the heat, the clock speed has slowed down in the past. |
| `0x80008` | Currently, the clock speed slows down due to heat. |

- Reference:
  [get_throttled](https://www.raspberrypi.com/documentation/computers/os.html#get_throttled) | `vcgencmd` | Doc @ raspberrypi.com

## Configuration

### raspi-config

- [configuation](https://www.raspberrypi.com/documentation/computers/configuration.html) | Doc @ raspberrypi.com

### Enable 64bit OS

- `/boot/config.txt`: Add `arm_64bit=1`
