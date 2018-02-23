#!/bin/bash
# TravisCI上でgitbookをビルドするスクリプト
# 参考: https://gist.github.com/domenic/ec8b0fc8ab45f39403dd
set -eux

SOURCE_BRANCH="master"
TARGET_BRANCH="gh-pages"
REPO=`git config remote.origin.url`
SSH_REPO=${REPO/https:\/\/github.com\//git@github.com:}
SHA=`git rev-parse --verify HEAD`
COMMIT_MESSAGE="Rebuild by Travis CI"

# masterブランチかどうかチェック
deploy_check_branch() {
  # gh-pagesブランチではビルドしない
  if [ "$TRAVIS_BRANCH" == "$TARGET_BRANCH" ]; then
    echo "Skipping deploy; branch is '$TARGET_BRANCH'"
    exit 0
  fi
  # master以外のブランチでは、ビルドが通るかだけチェックする
  if [ "$TRAVIS_PULL_REQUEST" != "false" -o "$TRAVIS_BRANCH" != "$SOURCE_BRANCH" ]; then
    echo "Skipping deploy; just doing a build."
    npm run build
    exit 0
  fi
}

# gh-pagesブランチをclone
deploy_clone() {
  git clone $REPO docs
  cd docs
  git checkout $TARGET_BRANCH
  cd ..
}

# gitbookをビルドする
# ビルド結果にdiffがなければ終了する
deploy_build() {
  npm run build
  cd docs
  if git diff --quiet; then
    echo "No changes to the output on this push; exiting."
    exit 0
  fi
  cd ..
}

# GitHubにpushするための準備
deploy_register() {
  ENCRYPTED_KEY_VAR="encrypted_${ENCRYPTION_LABEL}_key"
  ENCRYPTED_IV_VAR="encrypted_${ENCRYPTION_LABEL}_iv"
  ENCRYPTED_KEY=${!ENCRYPTED_KEY_VAR}
  ENCRYPTED_IV=${!ENCRYPTED_IV_VAR}
  openssl aes-256-cbc -K $ENCRYPTED_KEY -iv $ENCRYPTED_IV -in ./deploy_key.enc -out ./deploy_key -d
  chmod 600 ./deploy_key
  eval `ssh-agent -s`
  ssh-add ./deploy_key
}

# ビルド結果をcommit & push
deploy_push() {
  cd docs
  git config user.name "Travis CI"
  git config user.email "$COMMIT_AUTHOR_EMAIL"
  git add -A .
  git commit -m "$COMMIT_MESSAGE"
  git push $SSH_REPO $TARGET_BRANCH
}

# 後始末
deploy_reset() {
  unset -f deploy_check_branch deploy_clone deploy_build deploy_register deploy_push deploy_reset
  rm -rf ./deploy_key
}

# 終了時にdeploy_resetする
# bashの場合、SIGINT/SIGTERMが送られてもEXITが走る
trap deploy_reset EXIT

deploy_check_branch
deploy_clone
deploy_build
deploy_register
deploy_push
