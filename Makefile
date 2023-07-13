ARCH = sparc
BUILDROOT = 2023.02.2
REVISION = 1
MAINTAINER = $(shell git config user.name) <$(shell git config user.email)>

default: toolchain

buildroot-$(BUILDROOT)/:
	wget https://buildroot.org/downloads/buildroot-$(BUILDROOT).tar.gz
	tar xf buildroot-$(BUILDROOT).tar.gz
	cp $(ARCH)/.config buildroot-$(BUILDROOT)/

buildroot: buildroot-$(BUILDROOT)/

$(ARCH)-buildroot-linux-uclibc_sdk-buildroot.tar.gz: buildroot-$(BUILDROOT)/
	cd buildroot-$(BUILDROOT)/ && make sdk
	cp buildroot-$(BUILDROOT)/output/images/$(ARCH)-buildroot-linux-uclibc_sdk-buildroot.tar.gz .

toolchain: $(ARCH)-buildroot-linux-uclibc_sdk-buildroot.tar.gz

$(ARCH)-linux-toolchain_$(BUILDROOT)-$(REVISION).deb:
	mkdir -p $(ARCH)-linux-toolchain_$(BUILDROOT)-$(REVISION)
	mkdir -p $(ARCH)-linux-toolchain_$(BUILDROOT)-$(REVISION)/opt
	mkdir -p $(ARCH)-linux-toolchain_$(BUILDROOT)-$(REVISION)/usr/bin
	mkdir -p $(ARCH)-linux-toolchain_$(BUILDROOT)-$(REVISION)/DEBIAN

	echo "Package: $(ARCH)-linux-toolchain"                 >  $(ARCH)-linux-toolchain_$(BUILDROOT)-$(REVISION)/DEBIAN/control
	echo "Version: $(BUILDROOT)-$(REVISION)"                >> $(ARCH)-linux-toolchain_$(BUILDROOT)-$(REVISION)/DEBIAN/control
	echo "Architecture: $(shell dpkg --print-architecture)" >> $(ARCH)-linux-toolchain_$(BUILDROOT)-$(REVISION)/DEBIAN/control
	echo "Depends: qemu-user-static (>= 1.3.1)"             >> $(ARCH)-linux-toolchain_$(BUILDROOT)-$(REVISION)/DEBIAN/control
	echo "Maintainer: $(MAINTAINER)"                        >> $(ARCH)-linux-toolchain_$(BUILDROOT)-$(REVISION)/DEBIAN/control
	echo "Description: $(ARCH) Linux cross toolchain (GNU)" >> $(ARCH)-linux-toolchain_$(BUILDROOT)-$(REVISION)/DEBIAN/control

	tar xf $(ARCH)-buildroot-linux-uclibc_sdk-buildroot.tar.gz -C $(ARCH)-linux-toolchain_$(BUILDROOT)-$(REVISION)/opt
	cd $(ARCH)-linux-toolchain_$(BUILDROOT)-$(REVISION)/usr/bin && ln -sf ../../opt/$(ARCH)-buildroot-linux-uclibc_sdk-buildroot/bin/$(ARCH)-linux-* .
	cp $(ARCH)/$(ARCH)exec $(ARCH)-linux-toolchain_$(BUILDROOT)-$(REVISION)/usr/bin/$(ARCH)exec
	dpkg-deb --build $(ARCH)-linux-toolchain_$(BUILDROOT)-$(REVISION)

debian: $(ARCH)-linux-toolchain_$(BUILDROOT)-$(REVISION).deb

# fedora:
# 	mkdir -p rpmbuild/BUILD
# 	mkdir -p rpmbuild/BUILDROOT
# 	mkdir -p rpmbuild/RPMS
# 	mkdir -p rpmbuild/SOURCES
# 	mkdir -p rpmbuild/SPECS
# 	mkdir -p rpmbuild/SRPMS

clean:
	rm -f  *-linux-toolchain_*.deb
	rm -rf *-linux-toolchain_*/
	rm -f  *-buildroot-linux-uclibc_sdk-buildroot.tar.gz
	rm -f  buildroot-*.tar.gz
	rm -rf buildroot-*/

install:
	tar xf $(ARCH)-buildroot-linux-uclibc_sdk-buildroot.tar.gz -C /opt
	cd /usr/bin && ln -sf ../../opt/$(ARCH)-buildroot-linux-uclibc_sdk-buildroot/bin/$(ARCH)-linux-* .
	cp $(ARCH)/$(ARCH)exec /usr/bin/$(ARCH)exec

uninstall:
	rm -rf /opt/$(ARCH)-buildroot-linux-uclibc_sdk-buildroot
	rm -f  /usr/bin/$(ARCH)exec
	rm -f  /usr/bin/$(ARCH)-linux-*
