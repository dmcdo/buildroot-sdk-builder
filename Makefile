ARCH = sparc
BUILDROOT = 2023.02.4
REVISION = 1
MAINTAINER = $(shell git config user.name) <$(shell git config user.email)>
SHORTPREFIX = $(shell echo $(ARCH)-linux)
IMAGEPREFIX = $(shell cat $(ARCH)/image)
IMAGE = $(shell echo $(shell cat $(ARCH)/image)_sdk-buildroot)

default: toolchain

buildroot-$(BUILDROOT)/:
	wget https://buildroot.org/downloads/buildroot-$(BUILDROOT).tar.gz
	tar xf buildroot-$(BUILDROOT).tar.gz

buildroot: buildroot-$(BUILDROOT)/

$(IMAGE).tar.gz: buildroot-$(BUILDROOT)/
	cp $(ARCH)/.config buildroot-$(BUILDROOT)/
	cd buildroot-$(BUILDROOT)/ && make clean
	cd buildroot-$(BUILDROOT)/ && make sdk
	cp buildroot-$(BUILDROOT)/output/images/$(IMAGE).tar.gz .

toolchain: $(IMAGE).tar.gz

$(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION).deb: toolchain
	mkdir -p $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)
	mkdir -p $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/opt
	mkdir -p $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/usr/bin
	mkdir -p $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/usr/share/man/man1
	mkdir -p $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/DEBIAN

	echo "Package: $(SHORTPREFIX)-toolchain"                >  $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/DEBIAN/control
	echo "Version: $(BUILDROOT)-$(REVISION)"                >> $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/DEBIAN/control
	echo "Architecture: $(shell dpkg --print-architecture)" >> $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/DEBIAN/control
	echo "Depends: qemu-user-static (>= 1.3.1)"             >> $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/DEBIAN/control
	echo "Maintainer: $(MAINTAINER)"                        >> $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/DEBIAN/control
	echo "Description: $(ARCH) Linux cross toolchain (GNU)" >> $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/DEBIAN/control

	tar xf $(IMAGE).tar.gz -C $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/opt
	cd $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/usr/bin && ln -sf ../../opt/$(IMAGE)/bin/$(SHORTPREFIX)-* .
	cp $(ARCH)/$(ARCH)exec $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/usr/bin/$(ARCH)exec

	cp $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-g++.1 $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/usr/share/man/man1/$(SHORTPREFIX)-g++.1
	cp $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-objdump.1 $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/usr/share/man/man1/$(SHORTPREFIX)-objdump.1
	cp $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-gcov-tool.1 $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/usr/share/man/man1/$(SHORTPREFIX)-gcov-tool.1
	cp $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-gcov.1 $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/usr/share/man/man1/$(SHORTPREFIX)-gcov.1
	cp $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-addr2line.1 $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/usr/share/man/man1/$(SHORTPREFIX)-addr2line.1
	cp $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-strings.1 $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/usr/share/man/man1/$(SHORTPREFIX)-strings.1
	cp $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-elfedit.1 $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/usr/share/man/man1/$(SHORTPREFIX)-elfedit.1
	cp $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-windres.1 $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/usr/share/man/man1/$(SHORTPREFIX)-windres.1
	cp $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-c++filt.1 $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/usr/share/man/man1/$(SHORTPREFIX)-c++filt.1
	cp $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-lto-dump.1 $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/usr/share/man/man1/$(SHORTPREFIX)-lto-dump.1
	cp $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-gcc.1 $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/usr/share/man/man1/$(SHORTPREFIX)-gcc.1
	cp $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-objcopy.1 $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/usr/share/man/man1/$(SHORTPREFIX)-objcopy.1
	cp $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-dlltool.1 $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/usr/share/man/man1/$(SHORTPREFIX)-dlltool.1
	cp $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-size.1 $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/usr/share/man/man1/$(SHORTPREFIX)-size.1
	cp $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-gdb-add-index.1 $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/usr/share/man/man1/$(SHORTPREFIX)-gdb-add-index.1
	cp $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-as.1 $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/usr/share/man/man1/$(SHORTPREFIX)-as.1
	cp $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-windmc.1 $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/usr/share/man/man1/$(SHORTPREFIX)-windmc.1
	cp $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-readelf.1 $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/usr/share/man/man1/$(SHORTPREFIX)-readelf.1
	cp $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-ranlib.1 $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/usr/share/man/man1/$(SHORTPREFIX)-ranlib.1
	cp $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-strip.1 $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/usr/share/man/man1/$(SHORTPREFIX)-strip.1
	cp $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-ar.1 $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/usr/share/man/man1/$(SHORTPREFIX)-ar.1
	cp $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-nm.1 $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/usr/share/man/man1/$(SHORTPREFIX)-nm.1
	cp $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-ld.1 $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/usr/share/man/man1/$(SHORTPREFIX)-ld.1
	cp $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-gdbserver.1 $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/usr/share/man/man1/$(SHORTPREFIX)-gdbserver.1
	cp $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-gcov-dump.1 $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/usr/share/man/man1/$(SHORTPREFIX)-gcov-dump.1
	cp $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-gprof.1 $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/usr/share/man/man1/$(SHORTPREFIX)-gprof.1
	cp $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-gdb.1 $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/usr/share/man/man1/$(SHORTPREFIX)-gdb.1
	cp $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-cpp.1 $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)/usr/share/man/man1/$(SHORTPREFIX)-cpp.1

	dpkg-deb --build $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION)

debian: $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION).deb

docker:
	echo "FROM debian:bookworm"                                                 > Dockerfile.$(ARCH)
	echo "COPY $(SHORTPREFIX)-toolchain_$(BUILDROOT)-$(REVISION).deb /sdk.deb" >> Dockerfile.$(ARCH)
	echo "RUN apt -y update && \\"                                             >> Dockerfile.$(ARCH)
	echo "    apt -y upgrade && \\"                                            >> Dockerfile.$(ARCH)
	echo "    apt -y install /sdk.deb && \\"                                   >> Dockerfile.$(ARCH)
	echo "    rm sdk.deb"                                                      >> Dockerfile.$(ARCH)
	docker build -f Dockerfile.$(ARCH) -t $(ARCH)-linux-toolchain .

clean:
	rm -f  *-linux-toolchain_*.deb
	rm -rf *-linux-toolchain_*/
	rm -f  *-buildroot-linux-*_sdk-buildroot.tar.gz
	rm -f  buildroot-*.tar.gz
	rm -rf buildroot-*/
	rm -f  Dockerfile.*

install:
	tar xf $(IMAGE).tar.gz -C /opt
	cd /usr/bin && ln -sf ../../opt/$(IMAGE)/bin/$(SHORTPREFIX)-* .
	cp $(ARCH)/$(ARCH)exec /usr/bin/$(ARCH)exec
	mkdir -p /usr/share/man/man1
	cp /opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-g++.1 /usr/share/man/man1/$(SHORTPREFIX)-g++.1
	cp /opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-objdump.1 /usr/share/man/man1/$(SHORTPREFIX)-objdump.1
	cp /opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-gcov-tool.1 /usr/share/man/man1/$(SHORTPREFIX)-gcov-tool.1
	cp /opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-gcov.1 /usr/share/man/man1/$(SHORTPREFIX)-gcov.1
	cp /opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-addr2line.1 /usr/share/man/man1/$(SHORTPREFIX)-addr2line.1
	cp /opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-strings.1 /usr/share/man/man1/$(SHORTPREFIX)-strings.1
	cp /opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-elfedit.1 /usr/share/man/man1/$(SHORTPREFIX)-elfedit.1
	cp /opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-windres.1 /usr/share/man/man1/$(SHORTPREFIX)-windres.1
	cp /opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-c++filt.1 /usr/share/man/man1/$(SHORTPREFIX)-c++filt.1
	cp /opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-lto-dump.1 /usr/share/man/man1/$(SHORTPREFIX)-lto-dump.1
	cp /opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-gcc.1 /usr/share/man/man1/$(SHORTPREFIX)-gcc.1
	cp /opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-objcopy.1 /usr/share/man/man1/$(SHORTPREFIX)-objcopy.1
	cp /opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-dlltool.1 /usr/share/man/man1/$(SHORTPREFIX)-dlltool.1
	cp /opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-size.1 /usr/share/man/man1/$(SHORTPREFIX)-size.1
	cp /opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-gdb-add-index.1 /usr/share/man/man1/$(SHORTPREFIX)-gdb-add-index.1
	cp /opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-as.1 /usr/share/man/man1/$(SHORTPREFIX)-as.1
	cp /opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-windmc.1 /usr/share/man/man1/$(SHORTPREFIX)-windmc.1
	cp /opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-readelf.1 /usr/share/man/man1/$(SHORTPREFIX)-readelf.1
	cp /opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-ranlib.1 /usr/share/man/man1/$(SHORTPREFIX)-ranlib.1
	cp /opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-strip.1 /usr/share/man/man1/$(SHORTPREFIX)-strip.1
	cp /opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-ar.1 /usr/share/man/man1/$(SHORTPREFIX)-ar.1
	cp /opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-nm.1 /usr/share/man/man1/$(SHORTPREFIX)-nm.1
	cp /opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-ld.1 /usr/share/man/man1/$(SHORTPREFIX)-ld.1
	cp /opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-gdbserver.1 /usr/share/man/man1/$(SHORTPREFIX)-gdbserver.1
	cp /opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-gcov-dump.1 /usr/share/man/man1/$(SHORTPREFIX)-gcov-dump.1
	cp /opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-gprof.1 /usr/share/man/man1/$(SHORTPREFIX)-gprof.1
	cp /opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-gdb.1 /usr/share/man/man1/$(SHORTPREFIX)-gdb.1
	cp /opt/$(IMAGE)/usr/share/man/man1/$(IMAGEPREFIX)-cpp.1 /usr/share/man/man1/$(SHORTPREFIX)-cpp.1

uninstall:
	rm -rf /opt/$(IMAGE)
	rm -f  /usr/bin/$(ARCH)exec
	rm -f  /usr/bin/$(SHORTPREFIX)-*
	rm -f  /usr/share/man/man1/$(SHORTPREFIX)-*.1

debug_vars:
	echo "$(ARCH)"
	echo "$(BUILDROOT)"
	echo "$(REVISION)"
	echo "$(MAINTAINER)"
	echo "$(SHORTPREFIX)"
	echo "$(IMAGEPREFIX)"
	echo "$(IMAGE)"
