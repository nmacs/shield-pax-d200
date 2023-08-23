ifeq ($(KERNELRELEASE),)

.NOTPARALLEL:

KDIR ?= /lib/modules/$(shell uname -r)/build

all: modules

install: modules_install
	@# When compiling with stock kernel header on Debian, System.map does
	@# not exist. So, Kbuild does not run depmod and our shiny new modules is
	@# not seen
	@echo "Make sure depmod is up-to-date:"
	depmod

%.o: %.c
	$(MAKE) -C $(KDIR) M=$(shell pwd) $@

modules modules_install clean help:
	$(MAKE) -C $(KDIR) M=$(shell pwd) $@

deb-pkg:
	dkms mkdeb --source-only .

else

obj-m += ttyPos.o

endif
