#!/bin/bash
# instantiate this template with demo repo "go-template-demo"
# wipe everything
rm -rf *
# replace with template
cp /repo/root/* .
# swap placeholders
sed -i "s/GO_TEMPLATE_DEMO/$REPO_NAME/g" README.md
