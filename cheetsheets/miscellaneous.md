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
  <!-- markdownlint-disable-file MD001 MD033-->
  ```

- Exclusion of rules by file.
  - Filename: `.markdownlint.yaml`

    ```yaml
    MD041: false
    MD013:
        # Number of characters
        line_length: 120
    ```

## VSCode

### Comment out/in the selected code on macOS

- Comment out: ⌘ + K --> ⌘ + C
- Un-comment: ⌘ + K --> ⌘ + U
