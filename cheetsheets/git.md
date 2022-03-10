[INDEX](../)

---

# Git

## Append a commit to the previous commit

1 つ前のコミットに追加する方法。

```bash
git add .
git commit --amend --no-edit
git push --force
```

```bash
# One-liner
git add . && git commit --amend --no-edit && git push --force
```

## Create Orphan Branch

```bash
git checkout --orphan <new-branch-name>
```

## Rename branch from "master" to "main"

1. Change the name and push the branch as below.

  ```bash
  # Rename
  git branch -m master main
  git push -u origin main
  ```

2. Go to GitHub and change the default branch to main.

  * `[Settings]-[Branches]-[Default branch]`

3. Delete the old "master" branch.
