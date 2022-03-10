#!/bin/sh

set -eu

git add .
git commit -m "Update docs"
git push
