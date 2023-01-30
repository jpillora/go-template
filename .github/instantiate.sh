#!/bin/bash
# instantiate this template with demo repo "go-template-demo"

echo "$SSH_KEY" >/tmp/private.key
chmod 600 /tmp/private.key

# $GITHUB_WORKSPACE is GHA root
# $GITHUB_WORKSPACE/template is the template repo
# $GITHUB_WORKSPACE/demo is the demo repo

set -x

cd $GITHUB_WORKSPACE

# wipe everything
rm -rf $GITHUB_WORKSPACE/demo/*
# replace with template
cp -r $GITHUB_WORKSPACE/template/. $GITHUB_WORKSPACE/demo
# swap placeholders
# sed -i "s/GO_TEMPLATE_DEMO/$REPO_NAME/g" README.md

cd $GITHUB_WORKSPACE/demo
ls -lah
date >generated.txt
git config user.name go-template
git config user.email jpillora@users.noreply.github.com
git add .
git commit -m "generated"
git -c core.sshCommand="ssh -i /tmp/private.key" push
