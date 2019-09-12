#!/bin/bash
# GitHub Actions上でgitbookをビルドするスクリプト
# 参考: https://gist.github.com/domenic/ec8b0fc8ab45f39403dd
set -eux

SOURCE_BRANCH="master"
TARGET_BRANCH="gh-pages"
COMMIT_MESSAGE="Rebuild by CI"
COMMIT_AUTHOR_NAME="hatenabot"
COMMIT_AUTHOR_EMAIL="platform+githubhatenabot@hatena.ne.jp"
REPO=$(git config remote.origin.url)

# masterブランチかどうかチェック
deploy_check_branch() {
  # gh-pagesブランチではビルドしない
  if [ "$GITHUB_REF" == "refs/heads/$TARGET_BRANCH" ]; then
    echo "Skipping deploy; branch is '$TARGET_BRANCH'"
    exit 0
  fi
  # master以外のブランチでは、ビルドが通るかだけチェックする
  if [ "$GITHUB_REF" != "refs/heads/$SOURCE_BRANCH" ]; then
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

# ビルド結果をcommit & push
deploy_push() {
  cd docs
  git config user.name "$COMMIT_AUTHOR_NAME"
  git config user.email "$COMMIT_AUTHOR_EMAIL"
  git add -A .
  git commit -m "$COMMIT_MESSAGE"
  git push $REPO $TARGET_BRANCH
}

# 後始末
deploy_reset() {
  unset -f deploy_check_branch deploy_clone deploy_build deploy_push deploy_reset
}

# 終了時にdeploy_resetする
# bashの場合、SIGINT/SIGTERMが送られてもEXITが走る
trap deploy_reset EXIT

deploy_check_branch
deploy_clone
deploy_build
deploy_push
