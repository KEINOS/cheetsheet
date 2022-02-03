#!/bin/sh
# =============================================================================
#  index.md Generator
# =============================================================================
#  This script updates the index.md file from the markdown files in the docs dir.
#
#  - Requirements: `gh-md-toc` https://github.com/ekalinin/github-markdown-toc.go
#  - Install: Go or macOS Homebrew
#      go install "github.com/ekalinin/github-markdown-toc.go/cmd/gh-md-toc@latest"
#      brew install github-markdown-toc

# 定数
NAME_FILE_INDEX="index.md"
NAME_DIR_DOCS="cheetsheets"
PATH_DIR_RETURN="$(cd "$(pwd)" && pwd)"
PATH_DIR_SCRIPT="$(cd "$(dirname "${0}")" && pwd)"
PATH_DIR_REPO_ROOT="$(cd "${PATH_DIR_SCRIPT}/.." && pwd)"
PATH_FILE_INDEX="${PATH_DIR_REPO_ROOT}/index.md"
LF=$(printf '\n_')
LF=${LF%_}
HR="---${LF}"

# Defer change directory to the current dir after script execution
deferChDir() {
    cd "${PATH_DIR_RETURN}" || {
        echo >&2 "failed to move back: ${PATH_DIR_RETURN}"
        exit 1
    }
}
trap deferChDir 0

# Move current working directory to the root directory of the repo
cd "${PATH_DIR_REPO_ROOT}" || {
    echo >&2 "failed to move: ${PATH_DIR_REPO_ROOT}"
    exit 1
}

{
    # Print a header indicating that it has been generated automatically.
    printf "<!-- Code generated using /.github/gen-index.sh; DO NOT EDIT. -->\n" >"${PATH_FILE_INDEX}"

    # Add H1 title
    printf "# CheetSheet of KEINOS\n\n"
    printf "This is a memorandum/cheet-sheet for KEINOS.\n\n"
    printf "## Index\n\n"

    # Get a list of the index of Markdown files under the "cheetsheets" directory.
    # shellcheck disable=SC2046
    gh-md-toc --hide-header --hide-footer --serial $(find . -type f -name '*.md' ! -name 'index.md' ! -path './.github/*' | sort)

    # Add footer
    echo "${HR}"
    echo '* View the repository: [github.com/KEINOS/cheetsheets](https://github.com/KEINOS/cheetsheet) @ GitHub'
    echo '* Table of contents created by [gh-md-toc](https://github.com/ekalinin/github-markdown-toc.go)' @ GitHub

} >>"${PATH_FILE_INDEX}"

cat "${PATH_FILE_INDEX}" && echo "${HR}\ndone."