
TOPDIR=.
include $(TOPDIR)/conf.mk

DEBDIR=$(IMAGE_ROOT)/DEBIAN

all:	build debian

debian:	build $(DEBDIR)/control $(PACKAGE)-$(VERSION).deb

build:
	@$(MAKE) -C src all

$(PACKAGE)-$(VERSION).deb:	build
	dpkg --build $(IMAGE_ROOT) .

$(DEBDIR)/control:	control.in
	mkdir -p $(IMAGE_ROOT)/DEBIAN
	cat $< | \
	    sed -E 's/@PACKAGE@/$(PACKAGE)/' | \
	    sed -E 's/@VERSION@/$(VERSION)/' | \
	    sed -E 's/@DESCRIPTION@/$(DESCRIPTION)/' > $@

clean:
	@$(MAKE) -C src clean
	@rm -Rf $(DISTPREFIX) $(IMAGE_ROOT)
