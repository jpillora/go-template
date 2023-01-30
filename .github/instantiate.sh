#!/bin/bash
# setup private key
echo "$SSH_KEY" >/tmp/private.key
chmod 600 /tmp/private.key
# instantiate this template with demo repo "go-template-demo"
set -xeuf -o pipefail
# install dependencies
cd /tmp
curl 'https://i.jpillora.com/BurntSushi/ripgrep!?as=rg' | bash

# $GITHUB_WORKSPACE is GHA root
# $GITHUB_WORKSPACE/template is the template repo
# $GITHUB_WORKSPACE/demo is the demo repo
cd $GITHUB_WORKSPACE
pwd
# wipe everything
rm -rf $GITHUB_WORKSPACE/demo/*
# replace with template
cp -r $GITHUB_WORKSPACE/template/root/. $GITHUB_WORKSPACE/demo
cd $GITHUB_WORKSPACE/demo
pwd
ls -lah

# swap placeholders
rg --passthru 'myuser' -r 'jpillora' .
rg --passthru 'myrepo' -r 'go-template-demo' .

# confirm we can build
go mod init github.com/jpillora/go-template-demo
go mod tidy
go build -v -o /dev/null .

# mark as generated
echo "generated this repo at: $(date)" >generated.txt
git config user.name go-template
git config user.email jpillora@users.noreply.github.com
git add .
git commit -m "automated test from jpillora/go-template"
# push
git -c core.sshCommand="ssh -i /tmp/private.key" push
