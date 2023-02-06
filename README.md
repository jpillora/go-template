# go-template

A Go (golang) repository template which uses Github actions to automatically release cross-compiled binaries and Docker images

If you follow the **Quick start** guide, you'll end up with a repository like [go-template-demo](https://github.com/jpillora/go-template-demo), with binaries found under "Releases", and Docker images found under "Packages".

### Features

* Simple
  * No special tools, just copies `root/`
  * Won't replace existing files
  * Release on push tag in the form `v*`
  * Repo git tag (`vX.Y.Z`) compiled into `main.version`
* Github actions which will
  * Go build and test on all major platforms
  * Release cross compiled release binaries and Docker images for all major platforms
    * Binaries:
      * Performed by the awesome [`goreleaser`](https://github.com/goreleaser/goreleaser)
      * Assets are single gzip files (no archives)
      * Assumes `./main.go` (configured in `.github/goreleaser.yml`)
      * `main.go` `version` will be replaced with the tagged version
      * Packaged into `gz`, `apk`, `rpm`, and `deb`
    * Docker images:
      * Performed by buildx
      * Simple Dockerfile `FROM scratch`
      * Includes Alpine Root CA bundle
* Default README
  * Badges for Go doc, CI status, release downloads
* Default LICENSE

### Quick start

The quickest way to use this template is to run:

```sh
# create your new repository
mkdir myapp
cd myapp
curl https://jpillora.com/go-template/use.sh | USER=myuser REPO=myrepo bash
# follow the prompts...
# confirm you can 'go build'
go build -v -o /dev/null .
```

Alternatively, if you don't want to [use the script](use.sh), you can copy `root/` and manually replace `myuser`/`myrepo` across the files.

### Trigger release

Once copied, you have to commit these files into a Github repository to trigger Github Actions

```sh
# push to github
git init
git remote add origin git@github.com:YOURUSER/YOURREPO.git
git add -A
git commit -m 'initial commit'
git push -u origin master
git tag v1.0.0
git push --tags
```

Your [binaries should look like this](https://github.com/jpillora/go-template-demo/releases/latest), and your [docker images should look like this](https://github.com/jpillora/go-template-demo/pkgs/container/go-template-demo)

### Customisations

* If you're building a Go package to be imported by other Go programs, you will likely want to expand the build matrix:

  ```yml
  # update this section
  strategy:
    matrix:
      go-version: ['1.18', '1.19']
      platform: [ubuntu-latest, macos-latest, windows-latest]
  ```

* If you don't need Docker images, you can delete the Docker release job:

  ```yml
  # delete
  release_docker:
    name: Release Docker Images
    ...
  ```

* By default, `CGO_ENABLED=0` is set. If you want to enable CGO, update `.github/{Dockerfile,goreleaser.yml}`.

* By default, it uses your repositories inbuild Docker registry, however you can switch it to use Docker hub by updating the `docker/login` step, and the `image:` defintion

### Create own template

* Fork repository and customise
* Update `use.sh` to point back to your repo `curl -sL https://github.com/<user>/go-template/archive/<branch>.tar.gz | tar ...`

### Contributing

There are probably many improvements which can be made. Please send PRs! **Caveat** This is an opinionated repository template. I'm happy to fix any objective mistakes, however any subjective changes likely belong in individual forks.

