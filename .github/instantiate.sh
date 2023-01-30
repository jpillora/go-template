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
curl -sL https://github.com/jpillora/go-template/archive/demo.tar.gz | tar kxzvf - --strip-components 2
# swap placeholders in 3 files: go.mod, README.md, LICENSE
for f in go.mod README.md LICENSE; do
  sed -i 's/myuser/jpillora/g' $f
  sed -i 's/myrepo/go-template-demo/g' $f
done
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
