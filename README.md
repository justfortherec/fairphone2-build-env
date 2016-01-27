Creates an Android build environment for [Fairphone 2](http://www.fairphone.com) based on [official build instructions provided by Fairphone](http://code.fairphone.com/projects/fp-osos/dev/fairphone-os-build-instructions.html).

### Building the docker image

Get a pre-built image from Docker hub with `docker pull jftr/fairphone2-build-env` or use the [Dockerfile](https://github.com/justfortherec/fairphone2-build-env/blob/master/Dockerfile) to build yourself.

After building the image, build environment for Fairphone 2 is setup:

 * Dependencies are installed
 * `repo` is installed
 * Working directory inside the image is created

### Running the image

#### Mount shared volume

In order to make all changes persistent, `/var/fairphone_os/` should be mounted as a shared volume by using `docker run` with the `-v $PATH_ON_HOST/:/var/fairphone_os/` option (where `$PATH_ON_HOST` is the path at which you would want to store the repository and builds on your host. This should be empty initially).

#### Building Fairphone OS

All steps you need to take are described in [the official build instructions](http://code.fairphone.com/projects/fp-osos/dev/fairphone-os-build-instructions.html#initializing-the-repo).
In short:

 * Initialize and sync repository
 * Download binaries
 * (Optional: Make changes)
 * Build

All these steps (and some additions [discussed on the Fairphone community board](https://forum.fairphone.com/t/howto-pencil2-compiling-fairphone-open-source-rooting/11600)) can be executed with the default command of the image:

```
$ mkdir fairphone_os
$ PATH_ON_HOST=`readlink -f fairphone_os`
$ docker run -v $PATH_ON_HOST:/var/fairphone_os/ jftr/fairphone2-build-env
```

Alternatively you can get a shell and build manually (or continue an interrupted build without re-downloading all repositories):

```
$ docker run -v $PATH_ON_HOST:/var/fairphone_os/ -i -t jftr/fairphone2-build-env /bin/bash
```

Once your build is complete, you can find it in `$PATH_ON_HOST`.
Use your host to [flash the image](http://code.fairphone.com/projects/fp-osos/dev/fairphone-os-build-instructions.html#flash) to your Fairphone.

### Notes

 * **Mind:** This is a very basic example (e.g. `ccache` is not configured). Pull requests are welcome.
 * This is an unofficial image. I'm in no way associated with Fairphone.
 * I can't promise that this works for you. Flashing your phone with an image built using this docker image might fail. Flash at your own risk.

### Known issues

 * Building the docker image may fail in some configurations when installing `openjdk`. This seems to be [due to a kernel bug](https://github.com/docker/docker/issues/18180#issuecomment-162866404).

