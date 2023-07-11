[INDEX](../)

---

# macOS CheetSheet

This is a memorandum for KEINOS.

## Get OS version info

```shellsession
$ sw_vers
ProductName:    Mac OS X
ProductVersion: 10.15.7
BuildVersion:   19H1615
```

## How to check macOS Recovery Partition

```shellsession
$ # View partition
$ diskutil list
/dev/disk0 (internal, physical):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:      GUID_partition_scheme                        *500.1 GB   disk0
   1:                        EFI EFI                     209.7 MB   disk0s1
   2:                  Apple_HFS 名称未設定               499.2 GB   disk0s2
   3:                 Apple_Boot Recovery HD             650.0 MB   disk0s3

/dev/disk1 (external, physical):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:     FDisk_partition_scheme                        *15.5 GB    disk1
   1:                       0xEF                         2.1 MB     disk1s2
```

- Ref: [Will a clean install create a recovery partition?(https://discussions.apple.com/thread/6613513?answerId=26891623022#26891623022) @ discussions.apple.com

## Homebrew

### Run as a service

```bash
brew services start <name>
```

```shellsession
$ brew services start ipfs
...
```
