<!---
NOTE: AUTO-GENERATED FILE
to edit this file, instead edit its template at: ./scripts/templates/README.md.j2
-->
<div align="center">


## Containers

_An opinionated collection of container images_

</div>

<div align="center">

![GitHub Repo stars](https://img.shields.io/github/stars/skyssolutions/containers?style=for-the-badge)
![GitHub forks](https://img.shields.io/github/forks/skyssolutions/containers?style=for-the-badge)
![GitHub Workflow Status (with event)](https://img.shields.io/github/actions/workflow/status/skyssolutions/containers/scheduled-release.yaml?style=for-the-badge&label=Scheduled%20Release)

</div>

Welcome to my container images, if looking for a container start by [browsing the GitHub Packages page for this repo's packages](https://github.com/orgs/skyssolutions/packages?repo_name=containers).

## Mission statement

The goal of this project is to support [semantically versioned](https://semver.org/), [rootless](https://rootlesscontaine.rs/), and [multiple architecture](https://www.docker.com/blog/multi-arch-build-and-images-the-simple-way/) containers for various applications.

It also adheres to a [KISS principle](https://en.wikipedia.org/wiki/KISS_principle), logging to stdout, [one process per container](https://testdriven.io/tips/59de3279-4a2d-4556-9cd0-b444249ed31e/), no [s6-overlay](https://github.com/just-containers/s6-overlay) and most images are built on top of [Alpine](https://hub.docker.com/_/alpine),[Ubuntu](https://hub.docker.com/_/ubuntu) or [Debian](https://hub.docker.com/_/debian).

## Tag immutability

The containers built here do not use immutable tags, as least not in the more common way you have seen from [linuxserver.io](https://fleet.linuxserver.io/) or [Bitnami](https://bitnami.com/stacks/containers).

We do take a similar approach but instead of appending a `-ls69` or `-r420` prefix to the tag we instead insist on pinning to the sha256 digest of the image, while this is not as pretty it is just as functional in making the images immutable.

| Container                                                | Immutable |
|----------------------------------------------------------|-----------|
| `ghcr.io/skyssolutions/sonarr:rolling`                   | ❌         |
| `ghcr.io/skyssolutions/sonarr:3.0.8.1507`                | ❌         |
| `ghcr.io/skyssolutions/sonarr:rolling@sha256:8053...`    | ✅         |
| `ghcr.io/skyssolutions/sonarr:3.0.8.1507@sha256:8053...` | ✅         |

_If pinning an image to the sha256 digest, tools like [Renovate](https://github.com/renovatebot/renovate) support updating the container on a digest or application version change._

## Passing arguments to a application

Some applications do not support defining configuration via environment variables and instead only allow certain config to be set in the command line arguments for the app. To circumvent this, for applications that have an `entrypoint.sh` read below.

1. First read the Kubernetes docs on [defining command and arguments for a Container](https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/).
2. Look up the documentation for the application and find a argument you would like to set.
3. Set the extra arguments in the `args` section like below.

    ```yaml
    args:
      - --port
      - "8080"
    ```

## Configuration volume

For applications that need to have persistent configuration data the config volume is hardcoded to `/config` inside the container. This is not able to be changed in most cases.

## Available Images

Each Image will be built with a `rolling` tag, along with tags specific to it's version. Available Images Below

Container | Channel | Image | Mirror
--- | --- |-----| ---
[bind9](https://github.com/skyssolutions/pkgs/container/bind9) | nat64 | registry.skysolutions.fi/library/bind9 | ghcr.io/skyssolutions/bind9
[caddy-cf](https://github.com/skyssolutions/pkgs/container/caddy-cf) | stable | registry.skysolutions.fi/library/caddy-cf | ghcr.io/skyssolutions/caddy-cf
[cni-plugins](https://github.com/skyssolutions/pkgs/container/cni-plugins) | stable | registry.skysolutions.fi/library/cni-plugins | ghcr.io/skyssolutions/cni-plugins
[echoip](https://github.com/skyssolutions/pkgs/container/echoip) | latest | registry.skysolutions.fi/library/echoip | ghcr.io/skyssolutions/echoip
[mergerfs](https://github.com/skyssolutions/pkgs/container/mergerfs) | latest | registry.skysolutions.fi/library/mergerfs | ghcr.io/skyssolutions/mergerfs
[mongo-without-avx-5.0.18](https://github.com/skyssolutions/pkgs/container/mongo-without-avx-5.0.18) | 5.0.18 | registry.skysolutions.fi/library/mongo-without-avx-5.0.18 | ghcr.io/skyssolutions/mongo-without-avx-5.0.18
[mongo-without-avx-6.3.2](https://github.com/skyssolutions/pkgs/container/mongo-without-avx-6.3.2) | 6.3.2 | registry.skysolutions.fi/library/mongo-without-avx-6.3.2 | ghcr.io/skyssolutions/mongo-without-avx-6.3.2
[nginx-fancyindex](https://github.com/skyssolutions/pkgs/container/nginx-fancyindex) | latest | registry.skysolutions.fi/library/nginx-fancyindex | ghcr.io/skyssolutions/nginx-fancyindex
[paisa](https://github.com/skyssolutions/pkgs/container/paisa) | latest | registry.skysolutions.fi/library/paisa | ghcr.io/skyssolutions/paisa
[tvheadend](https://github.com/skyssolutions/pkgs/container/tvheadend) | stable | registry.skysolutions.fi/library/tvheadend | ghcr.io/skyssolutions/tvheadend
[unpackerr](https://github.com/skyssolutions/pkgs/container/unpackerr) | stable | registry.skysolutions.fi/library/unpackerr | ghcr.io/skyssolutions/unpackerr


## Deprecations

Containers here can be **deprecated** at any point, this could be for any reason described below.

1. The upstream application is **no longer actively developed**
2. The upstream application has an **official upstream container** that follows closely to the mission statement described here
3. The upstream application has been **replaced with a better alternative**
4. The **maintenance burden** of keeping the container here **is too bothersome**

**Note**: Deprecated containers will remained published to this repo for 6 months after which they will be pruned.

## Credits

A lot of inspiration and ideas are thanks to the hard work of [hotio.dev](https://hotio.dev/), [linuxserver.io](https://www.linuxserver.io/) and [onedr0p's container repo](https://https://github.com/onedr0p/containers) contributors.