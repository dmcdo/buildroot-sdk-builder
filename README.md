# buildroot-sdk-builder
Use [buildroot](https://buildroot.org/) to build a basic SPARC, MIPS, ARM, or AARCH64 Linux GNU C/++ toolchain and package it for Debian/Ubuntu.

All SPARC GNU tools are prefixed with `sparc-linux`. ie, `sparc-linux-gcc`, `sparc-linux-as`, `sparc-linux-ld`, etc. Tools for other architectures are prefixed similarly.

SPARC executables can be executed using the `sparcexec` command. `mipsexec` can be used for MIPS binaries, `armexec` for ARM binaries, and `aarch64exec` for ARM64 binaries.

```sh
# For example...
$ printf '#include <stdio.h>\nint main(void) { puts("Hello, World!"); }' > hello.c
$ sparc-linux-gcc hello.c -o hello
$ sparcexec hello
Hello, World!
```

## Building
Before building anything, you will need to install [buildroot's dependencies](https://buildroot.org/downloads/manual/manual.html#requirement-mandatory). Buildroot also requires that you have no whitespace characters in your PATH.

Currently supported values for `ARCH` are `sparc`, `mips`, `arm`, and `aarch64`. The default value is `sparc`.

### For Debian/Ubuntu
Building for Debian/Ubuntu requires dpkg-dev.

```sh
make debian           # SPARC is the default target
make debian ARCH=mips # but other arcitectures is also suppoted
```
This will build the toolchain and package it for Debian/Ubuntu systems.


### For Other Systems
Build the toolchain and install it with make.
```sh
make
sudo make install
make ARCH=mips
sudo make install ARCH=mips
```
This will install the toolchain to `/opt/sparc-buildroot-linux-uclibc_sdk-buildroot`. If necessary, you can uninstall the it with `sudo make uninstall`.


### For Docker
Building for Docker requires dpkg-dev. You can also use Podman for this.
```sh
make docker
make docker ARCH=mips
```
This will build a docker container with the tag (ARCH)-linux-toolchain.
<br />
Here is an example of how to compile and run a local C file using the Docker container. This example uses SPARC.
```sh
docker run --rm -v "$PWD":/src -w /src sparc-linux-toolchain sparc-linux-gcc hello.c -o hello
docker run --rm -v "$PWD":/src -w /src sparc-linux-toolchain sparcexec hello
```
If you just want the docker image without building the toolchain from scratch,
you can download the corresponding deb package for your desired architecture from
[the latest release](https://github.com/dmcdo/buildroot-sdk-builder/releases/latest),
place it the directory of this README, and follow the above instructions, changing
the necessary make variables when applicable.


### Just The Toolchain
```sh
make
make ARCH=mips
```
