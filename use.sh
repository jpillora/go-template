#!/bin/bash
set -euf -o pipefail
#TODO echo "initialise template into this directory? [y/n]"
TARGET=$(pwd)
# download into temp dir
DIR=$(mktemp -d -t tmplXXXX)
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
  exit 1
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
# copy into current dir
echo "copying..."
cp -r "./." "$TARGET"
rm -rf "$DIR"
echo "initialised go-template in $TARGET"
