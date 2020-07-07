# go-template

An automatic cross-compiling Go (golang) repository template using Github actions

### Features

* Simple
  * No special tools, just `curl` and `tar`
  * Won't replace existing files
* Github actions which will
  * Go build and test on all major platforms
  * Cross compile and release binaries for all major platforms
    * Performed by the awesome [`goreleaser`](https://github.com/goreleaser/goreleaser)
    * Assets are single gzip files (no archives)
    * Assumes `./main.go` (configured in `.github/goreleaser.yml`)
    * Only executed on a tag push
    * `main.go` `version` will be replaced with the tagged version
* Default README
  * Badges for Go doc, CI status, release downloads
* Default LICENSE
* Easily forkable
  * Replace template strings once and then `curl | tar` your fork

### Quick start

```sh
# copy the 'root' directory from this repo into the working directory
curl -sL https://github.com/jpillora/go-template/archive/master.tar.gz | tar kxzvf - --strip-components 2

# flags explained
curl --silent --location https://github.com/jpillora/go-template/archive/master.tar.gz | tar \
  --keep-old-files \
  --extract \
  --gzip \
  --file - \
  --verbose \
  --strip-components 2
```

### Demo

```sh
# create your new repository
mkdir myrepo
cd myrepo
# copy the 'root' directory from this repo into the working directory
curl -sL https://github.com/jpillora/go-template/archive/master.tar.gz | tar kxzvf - --strip-components 2
x .github/
x .github/goreleaser.yml
x .github/workflows/
x .github/workflows/ci.yml
x LICENSE
x README.md
x main.go
# optionally replace "myuser" and "myrepo" in README/LICENCE
# and you're ready to build
go mod init
git init
git remote add origin git@github.com:myuser/myrepo.git
git commit -am 'initial commit'
git push -u origin master
git tag v0.1.0
git push --tags
# see the repo's Actions page to watch your binaries being built...
# see the repo's Releases page to find your compiled binaries
```

### Customising

* Fork repository and customise
* Add a shell alias to `curl | tar` your custom fork

### Contributing

There are probably many improvements which can be made. Please send PRs! **Caveat** This is an opinionated repository template. I'm happy to fix any objective mistakes, however any subjective changes likely belong in individual forks.

