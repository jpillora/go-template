# go-template

A Go (golang) repository template containing a premade Github action which will automatically compile and release static binaries

### Features

* Simple
  * No special tools, just `curl` and `tar`
  * Won't replace existing files
* Easily forkable
  * Replace template strings once and then `curl | tar` your fork
* Default README
  * Badges for Go doc, CI status, release downloads
* Default LICENSE
* Github actions which will
  * Go build and test on all major platforms
  * Cross compile and release binaries for all major platforms
    * Performed by the awesome [`goreleaser`](https://github.com/goreleaser/goreleaser)
    * Assets are single gzip files (no archives)
    * Assumes `./main.go` (configured in `.github/goreleaser.yml`)
    * Only executed on a tag push
    * `main.go` `version` will be replaced with the tagged version

### Usage

Quick start

```sh
# create your new repository
mkdir myrepo
cd myrepo
# copy the 'root' directory from this repo into the working directory
curl -L https://github.com/jpillora/go-template/archive/master.tar.gz \
  | tar kxzvf - --strip-components 2 go-template/root
# optionally replace "myuser" and "myrepo" in README/LICENCE
# and you're ready to build
go mod init
git init
git remote add origin git@github.com:myuser/myrepo.git
git commit -am 'initial commit'
git push -u origin master
git tag v0.1.0
git push --tags
# see actions to watch your binaries being built...
# then find your binaries in your v0.1.0 release
```

Command explaination

```sh
curl --location https://github.com/tinode/chat/archive/master.tar.gz | tar \
  --keep-old-files \
  --extract \
  --gzip \
  --file - \
  --verbose \
  --strip-components 2 \
  go-template/root
```

### Customising

* Fork repository and customise
* Add a shell alias to `curl | tar` your custom fork

### Contributing

There are probably many improvements which can be made. Please send PRs!

**Caveat** This is an opinionated repository template. I'm happy to fix any objective mistakes, however any subjective changes will likely belong in individual forks.

