# go-template

A Go (golang) repository template

### Features

* Simple
  * No special tools, just `curl` and `tar`
  * Won't replace existing files
* Easily forkable
  * Replace template strings once and then `curl | tar` your fork
* Github actions which will
  * Go vet
  * Go test
  * Go build on all major platforms
  * Cross compile and release binaries to all major platforms
    * Performed by the awesome [`goreleaser`](https://github.com/goreleaser/goreleaser)
    * Assumes `package main` is at root, configurable to `cmd/my-program`
    * Only executed on a tag push
    * `main.go` `version` will be replaced with the tagged version

### Usage

Quick start

```sh
# create your new repository
$ git clone my-new-repo
$ cd my-new-repo
# copy the 'root' directory from this repo into the working directory
$ curl -L https://github.com/jpillora/go-template/archive/master.tar.gz \
  | tar kxzf - --strip-components=2 go-template/root
# TODO => replace strings
# and you're ready to build
$ go mod init
$ git add -A
$ git commit -m 'initial commit'
$ git push -u origin master
$ git tag v0.1.0
$ git push --tags
# see actions to watch your binaries being built...
# then find your binaries in your v0.1.0 release
```

Command explaination

```sh
curl --location https://github.com/tinode/chat/archive/master.tar.gz | tar \
  --keep-old-files \
  --gzip \
  --extract \
  --file - \
  --strip-components 2 \
  go-template/root
```

### Customising

* Fork repository and customise
* Add a shell alias to `curl | tar` your custom fork

### Contributing

There are probably many improvements which can be made. Please send PRs!

**Caveat** This is an opinionated repository template. I'm happy to fix any objective mistakes, however any subjective changes will likely belong in individual forks.

