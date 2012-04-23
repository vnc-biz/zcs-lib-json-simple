
include $(TOPDIR)/conf.mk

ifeq ($(ZCS_LIB_JARS),)
IMPORT_CP=`[ -d lib ] && find lib -name "*.jar" -exec "echo" "-n" "{}:" ";"`
else
IMPORT_ZCS=$(addprefix $(ZIMBRA_BUILD_ROOT)/lib/jars/,$(ZCS_LIB_JARS))
IMPORT_CP=`[ -d lib ] && find lib -name "*.jar" -exec "echo" "-n" "{}:" ";" ; find $(IMPORT_ZCS) -exec "echo" "-n" "{}:" ";"`
endif

SRCS=`find -L src -name "*.java"`

ZIMLET_USER_JARDIR=mailboxd/webapps/zimbra/WEB-INF/lib
ZIMLET_ADMIN_JARDIR=mailboxd/webapps/zimbraAdmin/WEB-INF/lib
ZIMLET_SERVICE_JARDIR=mailboxd/webapps/service/WEB-INF/lib
ZIMLET_LIB_JARDIR=lib/jars

all:	check-1	build

build:	install

ifeq ($(ZIMBRA_BUILD_ROOT),)
ZIMBRA_BUILD_ROOT=$(HOME)
check-1:
	@echo
	@echo "ZIMBRA_BUILD_ROOT is not set. assuming $$HOME"
	@echo
else
check-1:
	@true
endif

install:	$(JAR_FILE_NAME)
	@true
ifeq ($(INSTALL_USER),y)
	@mkdir -p $(IMAGE_ROOT)/$(ZIMLET_USER_JARDIR)
	@cp $(JAR_FILE_NAME) $(IMAGE_ROOT)/$(ZIMLET_USER_JARDIR)
endif
ifeq ($(INSTALL_ADMIN),y)
	@mkdir -p $(IMAGE_ROOT)/$(ZIMLET_ADMIN_JARDIR)
	@cp $(JAR_FILE_NAME) $(IMAGE_ROOT)/$(ZIMLET_ADMIN_JARDIR)
endif
ifeq ($(INSTALL_SERVICE),y)
	@mkdir -p $(IMAGE_ROOT)/$(ZIMLET_SERVICE_JARDIR)
	@cp $(JAR_FILE_NAME) $(IMAGE_ROOT)/$(ZIMLET_SERVICE_JARDIR)
endif
ifeq ($(INSTALL_LIB),y)
	@mkdir -p $(IMAGE_ROOT)/$(ZIMLET_LIB_JARDIR)
	@cp $(JAR_FILE_NAME) $(IMAGE_ROOT)/$(ZIMLET_LIB_JARDIR)
endif

clean:
	@rm -Rf \
		classes		\
		$(JAR_FILE_NAME)	\
		$(IMAGE_ROOT)/$(ZIMLET_SERVICE_JARDIR)/$(JAR_FILE_NAME)	\
		$(IMAGE_ROOT)/$(ZIMLET_ADMIN_JARDIR)/$(JAR_FILE_NAME)	\
		$(IMAGE_ROOT)/$(ZIMLET_USER_JARDIR)/$(JAR_FILE_NAME)

$(JAR_FILE_NAME):
	@mkdir -p `dirname "$@"`
	@mkdir -p classes
	@if [ "$(IMPORT_CP)" ]; then $(JAVAC) -d classes -cp $(IMPORT_CP) $(SRCS) ; else $(JAVAC) -d classes $(SRCS) ; fi
	@$(JAR) cvf $(JAR_FILE_NAME) -C classes .
