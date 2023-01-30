# go-template

An automatic cross-compiling Go (golang) repository template using [`goreleaser`](https://github.com/goreleaser/goreleaser) and Github actions

If you follow the **Quick start** guide, you'll end up with a repository like https://github.com/jpillora/go-template-demo, with binaries found under "Releases", and Docker images found under "Packages".

### Features

* Simple
  * No special tools, just `curl` and `tar`
  * Won't replace existing files
  * Repo git tag compiled into `main.version`
* Github actions which will
  * Go build and test on all major platforms
  * Cross compile and release binaries for all major platforms
    * Performed by the awesome [`goreleaser`](https://github.com/goreleaser/goreleaser)
    * Assets are single gzip files (no archives)
    * Assumes `./main.go` (configured in `.github/goreleaser.yml`)
    * Only executed on a tag push
    * `main.go` `version` will be replaced with the tagged version
    * Packaged into `gz`, `apk`, `rpm`, and `deb`
  * Cross compile and release Docker images for all major platforms
    * Performed by buildx
    * Simple Dockerfile `FROM scratch`
    * Includes Alpine root CA bundle
* Default README
  * Badges for Go doc, CI status, release downloads
* Default LICENSE
* Easily forkable
  * Replace template strings once and then `curl | tar` your fork

### Quick start

The quickest way to use this template is to run `curl https://jpillora.com/go-template/use.sh | bash` and follow the prompts. Once run, a templated set of files will be copied into your current working directory.

If you don't want to use this script, you can copy `root/` and manually replace `myuser`/`myrepo` across the files.

Once copied, you have to commit these files into a Github repository to trigger Github Actions

### Example

```sh
# create your new repository
mkdir myrepo
cd myrepo
curl https://jpillora.com/go-template/use.sh | bash
# push to github
git init
git remote add origin git@github.com:YOURUSER/YOURREPO.git
git add -A
git commit -m 'initial commit'
git push -u origin master
git tag v0.1.0
git push --tags
# see the repo's Actions page to watch your binaries being built...
# see the repo's Releases page to find your compiled binaries
```

Your [binaries should look like this](https://github.com/jpillora/go-template-demo/releases/latest), and your [docker images should look like this](https://github.com/users/jpillora/packages?repo_name=go-template-demo)

### Customise

* If you're building a Go package to be imported by other Go programs, you will likely want a build matrix

  ```yml
  # update this section
  strategy:
    matrix:
      go-version: ['1.18', '1.19']
      platform: [ubuntu-latest, macos-latest, windows-latest]
  ```

* If you don't need Docker images, you can delete the Docker release job

  ```yml
  # delete
  release_docker:
    name: Release Docker Images
    ...
  ```

### Create own template

* Fork repository and customise
* Add a shell alias to `curl | tar` your custom fork

### Contributing

There are probably many improvements which can be made. Please send PRs! **Caveat** This is an opinionated repository template. I'm happy to fix any objective mistakes, however any subjective changes likely belong in individual forks.

