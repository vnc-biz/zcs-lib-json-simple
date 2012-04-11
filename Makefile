
TOPDIR=.
include $(TOPDIR)/conf.mk

DEBDIR=$(IMAGE_ROOT)/DEBIAN
DEBFILE=$(PACKAGE)_$(VERSION)_$(ARCHITECTURE).deb

all:	$(DEBFILE)

prepare:
	@echo -n > $(TOPDIR)/zimlets.list

build-zimlets:	prepare
	@$(MAKE) -C src all

$(DEBFILE)::	$(DEBDIR)/control build-zimlets
	@dpkg --build $(IMAGE_ROOT) .

$(DEBDIR)/control:	control.in
	@mkdir -p $(IMAGE_ROOT)/DEBIAN
	@cat $< | \
	    sed -E 's/@PACKAGE@/$(PACKAGE)/' | \
	    sed -E 's/@VERSION@/$(VERSION)/' | \
	    sed -E 's/@MAINTAINER@/$(MAINTAINER)/' | \
	    sed -E 's/@SECTION@/$(SECTION)/' | \
	    sed -E 's/@ARCHITECTURE@/$(ARCHITECTURE)/' | \
	    sed -E 's/@PRIORITY@/$(PRIORITY)/' | \
	    sed -E 's/@DEPENDS@/$(DEPENDS)/' | \
	    sed -E 's/@DESCRIPTION@/$(DESCRIPTION)/' | \
	    grep -vE "^Depends: __NONE__" > $@

clean:
	@$(MAKE) -C src clean
	@rm -Rf $(DISTPREFIX) $(IMAGE_ROOT) $(DEBFILE) zimlets.list

upload:	all
	@if [ ! "$(REDMINE_UPLOAD_USER)" ]; then echo "REDMINE_UPLOAD_USER environment variable must be set" ; exit 1 ; fi
	@if [ ! "$(REDMINE_UPLOAD_PASSWORD)" ]; then echo "REDMINE_UPLOAD_PASSWORD environment variable must be set" ; exit 1 ; fi
	@if [ ! "$(REDMINE_UPLOAD_URL)" ]; then echo "REDMINE_UPLOAD_URL variable must be set" ; exit 1 ; fi
	@if [ ! "$(REDMINE_UPLOAD_PROJECT)" ]; then echo "REDMINE_UPLOAD_PROJECT variable must be set" ; exit 1 ; fi
	@upload_file_to_redmine.py		\
		-f $(DEBFILE)			\
		-l $(REDMINE_UPLOAD_URL)	\
		-u $(REDMINE_UPLOAD_USER)	\
		-w $(REDMINE_UPLOAD_PASSWORD)	\
		-p $(REDMINE_UPLOAD_PROJECT)	\
		-d "$(DEBFILE)"
