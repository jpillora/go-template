#!/bin/bash
set -euf -o pipefail
[ "${DEBUG:-0}" -eq 1 ] && set -x
# prepare temp dir
DIR=$(mktemp -d -t tmplXXXX)
# always remove temp dir
function cleanup {
  rm -rf "$DIR" >/dev/null
}
function fail {
  cleanup
  msg=$1
  echo "Error: $msg" 1>&2
  exit 1
}
function template {
  which curl >/dev/null || fail "curl not installed"
  which tar >/dev/null || fail "tar not installed"
  which sed >/dev/null || fail "sed not installed"
  local USER="${USER:-}"
  local REPO="${REPO:-}"
  # extract user/repo from git remote
  if [ -z "${USER:-}" ] || [ -z "${REPO:-}" ]; then
    which awk >/dev/null || fail "awk not installed"
    # get remote url and extract user/repo from url
    local URL=$(git config --get remote.origin.url | sed 's/\.git$//' || true)
    USER=$(echo $URL | awk -F'/' '{print $(NF-1)}' || true)
    REPO=$(echo $URL | awk -F'/' '{print $NF}' || true)
  fi
  [ -n "${USER:-}" ] || fail "USER environment variables must be set"
  [ -n "${REPO:-}" ] || fail "REPO environment variables must be set"
  #TODO echo "initialise template into this directory? [y/n]"
  TARGET=$(pwd)
  # download into temp dir
  echo "downloading go-template..."
  curl -sL https://github.com/jpillora/go-template/archive/master.tar.gz | tar xzf - -C "$DIR"
  # switch into temp dir
  cd $DIR/go-template-master/root
  # template files
  for F in "go.mod" "README.md" "LICENSE"; do
    sed -i.bak "s/myuser/$USER/g" "$F"
    rm $F.bak
    sed -i.bak "s/myrepo/$REPO/g" "$F"
    rm $F.bak
    echo "inserting $USER/$REPO into $F"
  done
  # drop template into TARGET (recursive, verbose, no-clobber)
  echo "copying..."
  cp -r -v -n "./." "$TARGET"
  echo "initialised go-template in $TARGET"
  #done
  cleanup
}
template
