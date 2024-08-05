#!/bin/bash
# setup private key
echo "$SSH_KEY" >/tmp/private.key
chmod 600 /tmp/private.key
# instantiate this template with demo repo "go-template-demo"
set -xeuf -o pipefail
# clone demo
git -c core.sshCommand="ssh -i /tmp/private.key" clone git@github.com:jpillora/go-template-demo.git demofull
mkdir demo
mv demofull/.git demo/.git
cd demo
# test template "Quick start" (from demo branch)
curl https://raw.githubusercontent.com/jpillora/go-template/demo/use.sh | sed 's/master/demo/' | USER=jpillora REPO=go-template-demo bash
# confirm we can build
go build -v -o /dev/null .
# mark as generated
echo "generated this repo at: $(date)" >generated.txt
# commit
git config user.name "Jaime Pillora"
git config user.email jpillora@users.noreply.github.com
git add -A
git commit -m "automated test from jpillora/go-template (build #$BUILD_NUM)"
git tag "v1.0.$BUILD_NUM"
# push
git -c core.sshCommand="ssh -i /tmp/private.key" push
git -c core.sshCommand="ssh -i /tmp/private.key" push --tags
