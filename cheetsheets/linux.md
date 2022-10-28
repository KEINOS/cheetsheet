[INDEX](../)

---

# Linux CheetSheet

This is a memorandum for KEINOS.

## Command Alias

```bash
alias ll='ls -l'
```

## How to check users in a Linux system

```bash
cat /etc/passwd | sort
```

## How to get the filesystem name of the root directory's partition

```bash
df -l / | grep dev | awk '{ print $1 }'
```

```shellsession
$ df -l /
Filesystem     1K-blocks    Used Available Use% Mounted on
/dev/vda3       99014644 2660412  91304892   3% /

$ df -l / | grep dev | awk '{ print $1 }'
/dev/vda3
```

- Tested on Ubuntu 20.04

## systemd

### How to check systemctl error log

```bash
journalctl | grep <service>
```

### View all services' status

```bash
systemctl list-unit-files --type=service
```

### View service log

```bash
sudo journalctl -f -u <service>

# Example
journalctl -fu ipfs.service
```

### Reasons to get "Active: inactive (dead)"

- You mey not be anabled to use the service.

```bash
sudo systemctl status <service>
```

## AlpineLinux

This is a list of basic apk packages that must be installed to develop and build Go applications on Alpine Linux.

```bash
apk add --no-cache alpine-sdk build-base
```

## Ubuntu

Check graphics driver.

```bash
$ # Check graphics devices
$ ubuntu-drivers devices
...
$ # Install the driver (Depends on driver)
$ sudo apt install nvidia-driver-510 nvidia-dkms-510
...
$ # Check the driver
$ nvidia-smi
...
```

### How to install Japanese language pack on Ubuntu/Debian

- Error messages:

    ```bash
    warning: setlocale: LC_ALL: cannot change locale (ja_JP.UTF-8)
    ```

    ```bash
    perl: warning: Setting locale failed.
    perl: warning: Please check that your locale settings:
        LANGUAGE = (unset),
        LC_ALL = "ja_JP.UTF-8",
        LANG = "en_US.UTF-8"
        are supported and installed on your system.
    perl: warning: Falling back to a fallback locale ("en_US.UTF-8").
    ```

- Solution: `sudo apt-get install language-pack-ja`
