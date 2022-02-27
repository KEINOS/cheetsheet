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

## AlpineLinux

This is a list of basic apk packages that must be installed to develop and build Go applications on Alpine Linux.

```bash
apk add --no-cache alpine-sdk build-base
```
