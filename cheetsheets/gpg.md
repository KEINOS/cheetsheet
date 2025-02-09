[INDEX](../)

---

# GPG (OpenPGP/GnuPG)

`gpg`(GnuPG) command is an implementation of the OpenPGP standard.

## References

- [新しい GPG キーを生成する](https://docs.github.com/ja/authentication/managing-commit-signature-verification/generating-a-new-gpg-key) @ docs.github.com
- [Signing Git commits with GPG keys that use modern encryption](https://dev.to/benjaminblack/signing-git-commits-with-modern-encryption-1koh) @ dev.to
- [Signing](https://github.com/goreleaser/goreleaser-action#signing) | goreleaser-action @ GitHub
- [Signing checksums and artifacts](https://goreleaser.com/customization/sign/) @ goreleaser.com
- [GnuPG チートシート（簡易版）](https://qiita.com/spiegel-im-spiegel/items/079d69282166281eb946) @ Qiita
- [GnuPGを使おう](https://okumuralab.org/~okumura/misc/220628.html) | misc | ~okumura @ okumuralab.org

## How to create GPG key pair

### One-liner with no interaction

```bash
# Install GPG on Alpine Linux
# apk add gpg gpg-agent

myID="MyName <my_name@example.com>"

# gpg --batch --quick-gen-key --passphrase '' <User ID> [algo [usage [expire]]]
gpg --batch --expert --quick-gen-key --passphrase '' "$myID" default default 0

# Export the public key and private key to PEM files
gpg --armor --export "$myID$" > public_key.pem
gpg --armor --export-secret-keys "$myID" > private_key.pem
```

### Interactive

```bash
gpg --full-generate-key --expert
```

- `ed25519` Based Key Pair: Preferable settings
  - Key Type: `ECC` both sign and encrypt<br>鍵の種類: `ECC` 署名と暗号化
  - Elliptic Curve: `Curve 25519`<br>楕円曲線: `Curve 25519`

## How to sign a file with GPG key

```bash
gpg --sign <file>
```

```bash
gpg --sign --default-key <email@address> <file>
```

## How to verify the signed file

```bash
gpg --verify <file>.gpg
```

```bash
gpg --verify --default-key <email@address> <file>.gpg
```

## Assign PGP key to `git` commit

- [Git へ署名キーを伝える](https://docs.github.com/ja/authentication/managing-commit-signature-verification/telling-git-about-your-signing-key) @ docs.github.com

## How to get existing GPG key info

```bash
# Public Key
gpg --list-keys
gpg --list-keys --keyid-format=long
gpg --list-keys --keyid-format=short
```

```bash
# Secret Key
gpg --list-secret-keys
gpg --list-secret-keys --keyid-format=long
gpg --list-secret-keys --keyid-format=short
```

## Whow to get the fingerprint of a GPG key

```bash
gpg --list-keys --fingerprint --keyid-format=short
```

```bash
gpg --list-keys --fingerprint --keyid-format=short
/Users/admin/.gnupg/pubring.kbx
-------------------------------
pub   ed25519/23FEC570 2024-01-15 [SC]
   フィンガープリント = 74B7 0607 675F BED0 0951  8600 0E31 BF09 23FE C570
uid         [  究極  ] KEINOS (ECC-Curve25519-Full_Enc-Sign) <github@keinos.com>
sub   cv25519/DB6B3F2A 2024-01-15 [E]
```

## How to upload GPG key to key-server (keys.openpgp.org)

```bash
gpg --keyserver hkps://keys.openpgp.org --send-keys <finger print>
```

```bash
gpg --keyserver hkps://keys.openpgp.org --send-keys 74B70607675FBED0095186000E31BF0923FEC570
```

## How to get current GPG Keys (Public and Private)

- List all key IDs. In the below example "`3AA5C34371567BD2`" is the key ID.

  ```shellsession
  $ gpg --list-secret-keys --keyid-format=long
  /Users/hubot/.gnupg/secring.gpg
  ------------------------------------
  sec   4096R/3AA5C34371567BD2 2016-03-10 [expires: 2017-03-10]
  uid                          Hubot
  ssb   4096R/42B317FD4BA89E7A 2016-03-10
  ```

- Show Public Key generated from a Secret (sec) Key.
  The output text is the public key to register to GitHub's GPG key section.

  ```shellsession
  $ gpg --armor --export 3AA5C34371567BD2
  -----BEGIN PGP PUBLIC KEY BLOCK-----
  ...
  -----END PGP PUBLIC KEY BLOCK-----
  ```

- Show the secret key.

  ```shellsession
  $ gpg --armor --export-secret-keys 3AA5C34371567BD2
  -----BEGIN PGP PRIVATE KEY BLOCK-----
  ...
  -----END PGP PRIVATE KEY BLOCK-----
  ```
