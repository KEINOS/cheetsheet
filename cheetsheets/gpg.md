[INDEX](../)

---

# GPG(OpenPGP/GnuPG)

`gpg`(GnuPG) command is an implementation of the OpenPGP standard.

## Create GPG Key Pair

```bash
gpg --full-generate-key --expert
```

- `ed25519` Based Key Pair: Preferable settings
  - Key Type（鍵の種類）: `ECC` (署名と暗号化)
  - Elliptic Curve（楕円曲線）: `Curve 25519`

## Show GPG Key Info

```bash
gpg --list-keys --keyid-format short
```

## Show GPG Keys (Public and Private)

- List all key IDs. In the below example "`3AA5C34371567BD2`" is the key ID.

  ```shellsession
  $ pg --list-secret-keys --keyid-format=long
  /Users/hubot/.gnupg/secring.gpg
  ------------------------------------
  sec   4096R/3AA5C34371567BD2 2016-03-10 [expires: 2017-03-10]
  uid                          Hubot
  ssb   4096R/42B317FD4BA89E7A 2016-03-10
  ```

- Show Public Key generated from a Secret (sec) Key.

  ```shellsession
  $ gpg --armor --export 3AA5C34371567BD2
  -----BEGIN PGP PUBLIC KEY BLOCK-----
  ...
  -----END PGP PUBLIC KEY BLOCK-----
  ```

- Show the secret key.

  ```shellsession
  $ gpg --export-secret-keys --armor 3AA5C34371567BD2
  -----BEGIN PGP PRIVATE KEY BLOCK-----
  ...
  -----END PGP PRIVATE KEY BLOCK-----
  ```
