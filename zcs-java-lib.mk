
include $(TOPDIR)/conf.mk

IMPORT_CP=`[ -d lib ] && find lib -name "*.jar" -exec "echo" "-n" "{}:" ";"`
SRCS=`find -L src -name "*.java"`

ZIMLET_USER_JARDIR=mailboxd/webapps/zimbra/WEB-INF/lib
ZIMLET_ADMIN_JARDIR=mailboxd/webapps/zimbraAdmin/WEB-INF/lib
ZIMLET_SERVICE_JARDIR=mailboxd/webapps/service/WEB-INF/lib

all:	build

build:	install_user install_admin install_service

ifeq ($(INSTALL_USER),y)
install_user:	$(JAR_FILE_NAME)
	@mkdir -p $(IMAGE_ROOT)/$(ZIMLET_USER_JARDIR)
	@cp $(JAR_FILE_NAME) $(IMAGE_ROOT)/$(ZIMLET_USER_JARDIR)
else
install_user:
	@echo -n
endif

ifeq ($(INSTALL_ADMIN),y)
install_admin:	$(JAR_FILE_NAME)
	@mkdir -p $(IMAGE_ROOT)/$(ZIMLET_ADMIN_JARDIR)
	@cp $(JAR_FILE_NAME) $(IMAGE_ROOT)/$(ZIMLET_ADMIN_JARDIR)
else
install_admin:
	@echo -n
endif

ifeq ($(INSTALL_SERVICE),y)
install_service:	$(JAR_FILE_NAME)
	@mkdir -p $(IMAGE_ROOT)/$(ZIMLET_SERVICE_JARDIR)
	@cp $(JAR_FILE_NAME) $(IMAGE_ROOT)/$(ZIMLET_SERVICE_JARDIR)
else
install_service:
	@echo -n
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
