#!/bin/sh

set -e

unset X_PACT_DEVELOPMENT

git pull origin master

bundle exec rake package:update

if git log -1 | grep "feat(gems)"; then
  bundle exec bump ${1:-minor} --no-commit
  bundle exec rake generate_changelog
  git add lib/pact/cli/version.rb
  git commit -m "chore(release): version $(cat VERSION)" && git push origin master
  bundle exec rake tag_for_release
else
  echo "No gems updated, not releasing"
fi