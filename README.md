### atomic-preload

There are various scenarios where it would be advantageous
to bundle container images inside a cloud image so that they
do not need to be downloaded on every provisioned machine
(e.g. guest agents, monitoring/logging tools, etc...).

`atomic-preload` makes use of the
`atomic` [tool](https://github.com/projectatomic/atomic) to
load and possibly start both regular Docker containers as
well as system containers.

Images and are kept in `/var/lib/atomic/preload`, in either
the `ostree` subdir or the `docker` subdir, depending on the
storage backend in which you'd like the image to be
imported.

A `config.yaml` file holds information about how the
containers should be installed and run if desired. For
example, in this config we start both busybox and etcd:

```yaml
- name: busybox_sleep
  image: docker.io/busybox
  run:
    extra_args:
      - sleep
      - "999"

- name: etcd
  image: docker.io/gscrivano/etcd
  install:
    system: true
    setvalues:
      - ETCD_NAME=myetcd
  run: {} # use default vars
```

Because the install and run operations are not actually
carried out until the Docker daemon is up, users can modify
the default configurations from cloud-init using e.g. the
`bootcmd` or `write_files` modules.

`atomic-preload` consists of two parts:
  - a package containing systemd services for loading and
    optionally starting the containers, and
  - an Anaconda add-on for allowing kickstart writers to
    declare which containers to preload. (TODO)

### Usage

The kickstart defines the container images to inject into
the cloud image. Direct URLs to tar files are expected (in
the future, we might use skopeo here to specify e.g. a
Docker registry once it supports outputting tars directly).

The kickstart may also define the default post-import
actions to take, such as installing and starting the
containers. These actions may be overridden by cloud-init.

Example:

```
%addon org_projectatomic_atomic_preloader \
    --preload-docker http://example.com/container.tar.gz \
    --preload-system http://example.com/syscontainer.tar.xz
- name: mysyscontainer
  install:
    system: true
  run: {}
%end
```

Overridding in cloud-init:

```yaml
write_files:
  - path: /var/lib/atomic/preload/config.yaml
    content: |
      - name: mysyscontainer
        install:
          system: true
          setvalues:
            - VAR1=nondefaultval1
        # no run entry, we don't want to start it
```

### Related projects

- There is a
  [Docker Anaconda addon](https://rhinstaller.github.io/docker-anaconda-addon/docker-anaconda-addon.html)
  capable of configuring Docker storage and running Docker
  commands post-installation. This means that the storage
  strategy must be chosen at kickstart time. This is a
  better choice if customizing images for your own
  environment, but may not be feasible if the images must be
  kept generic.

- RancherOS has an analogous
  [feature](http://docs.rancher.com/os/configuration/prepacking-docker-images/),
  though it does not support starting containers by default.
