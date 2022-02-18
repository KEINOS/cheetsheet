[INDEX](../)

---

# General/Miscellaneous

This is a memorandum for KEINOS.

## Markdown

- [Qiita Flavored Markdown](https://qiita.com/Qiita/items/c686397e4a0f4f11683d) @ Qiita
- [GitHub Flavored Markdown](https://github.github.com/gfm/) | Official @ GitHub

## MarkdownLint

- [Rules](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md) | markdownlint @ GitHub
- Exclusion of rules by name.

  ```bash
  <!-- markdownlint-disable-file MD001 -->
  ```

- Exclusion of rules by file.
  - Filename: `.markdownlint.yaml`

    ```yaml
    MD041: false
    MD013:
        # Number of characters
        line_length: 120
    ```

## Git

### Append a commit to the previous commit

1 つ前のコミットに追加する方法。

```bash
git commit --amend --no-edit
git push --force
```

### Create Orphan Branch

```bash
git checkout --orphan <new-branch-name>
```

### Rename branch from "master" to "main"

1. Change the name and push the branch as below.

  ```bash
  # Rename
  git branch -m master main
  git push -u origin main
  ```

2. Go to GitHub and change the default branch to main.

  * `[Settings]-[Branches]-[Default branch]`

3. Delete the old "master" branch.
