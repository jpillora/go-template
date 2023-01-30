#!/bin/bash
# setup private key
echo "$SSH_KEY" >/tmp/private.key
chmod 600 /tmp/private.key
# instantiate this template with demo repo "go-template-demo"
set -xeuf -o pipefail
# install dependencies
cd /tmp
curl -s 'https://i.jpillora.com/BurntSushi/ripgrep!?as=rg' | bash

# $GITHUB_WORKSPACE is GHA root
# $GITHUB_WORKSPACE/template is the template repo
# $GITHUB_WORKSPACE/demo is the demo repo

cd $GITHUB_WORKSPACE/demo
echo "should be demo dir: $(pwd)"

# wipe everything
rm -rfv ./*
echo "should have wiped:"
ls -lah

# test template "Quick start"
curl -sL https://github.com/jpillora/go-template/archive/master.tar.gz | tar kxzvf - --strip-components 2
echo "should be template root:"
ls -lah

# swap placeholders
rg 'myuser' --files-with-matches | xargs sed -i '' 's/myuser/jpillora/g'
rg 'myrepo' --files-with-matches | xargs sed -i '' 's/myrepo/go-template-demo/g'

# confirm we can build
go mod init github.com/jpillora/go-template-demo
go mod tidy
go build -v -o /dev/null .

# mark as generated
echo "generated this repo at: $(date)" >generated.txt

# commit
git config user.name go-template
git config user.email jpillora@users.noreply.github.com
git add .
git commit -m "automated test from jpillora/go-template"

# push
git -c core.sshCommand="ssh -i /tmp/private.key" push
