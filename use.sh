#!/bin/bash
set -euf -o pipefail
# prepare temp dir
DIR=$(mktemp -d -t tmplXXXX)
# always remove temp dir
function cleanup {
  rm -rf "$DIR" > /dev/null
}
function fail {
  cleanup
  msg=$1
  echo "============"
  echo "Error: $msg" 1>&2
  exit 1
}
function template {
	which curl > /dev/null || fail "curl not installed"
	which tar > /dev/null || fail "tar not installed"
	which sed > /dev/null || fail "sed not installed"
  #TODO echo "initialise template into this directory? [y/n]"
  TARGET=$(pwd)
  # download into temp dir
  echo "downloading go-template..."
  curl -sL https://github.com/jpillora/go-template/archive/master.tar.gz | tar xzf - -C "$DIR"
  # capture user info
  USERNAME=${USERNAME:-}
  echo -n "github user: $USERNAME"
  while [ -z "$USERNAME" ]; do
    read USERNAME
  done
  REPO=${REPO:-}
  echo -n "github repo: $REPO"
  while [ -z "$REPO" ]; do
    read REPO
  done
  CONFIRM=${CONFIRM:-}
  echo -n "using 'github.com/$USERNAME/$REPO'"
  while [ -z "$CONFIRM" ]; do
    echo -n " confirm? [y/n]"
    read CONFIRM
  done
  if [ "$CONFIRM" != "y" ]; then
    fail "cancelled"
  fi
  # switch into temp dir
  cd $DIR/go-template-master/root
  # template files
  for F in go.mod README.md LICENSE; do
    sed -i.bak "s/myuser/$USERNAME/g" $F
    rm $F.bak
    sed -i.bak "s/myrepo/$REPO/g" $F
    rm $F.bak
  done
  #TODO git remote add origin? ssh http?
  # echo "do you want to git init this repo? [y/n]"
  # read INIT
  # if [ "$INIT" == "y" ]; then
  #   git init
  #   git add .
  #   git commit -m "initial commit"
  # fi
  # drop template into TARGET
  echo "copying..."
  cp --recursive --verbose --no-clobber "./." "$TARGET"
  echo "initialised go-template in $TARGET"
  #done
  cleanup
}
template