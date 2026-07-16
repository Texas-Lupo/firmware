################################################################################
#
# qlink
#
################################################################################

# Use the specific commit hash or branch name (e.g., master)
FLUKE_VERSION = 805d56080ba0c93f56e70964859267b4858c3a93
FLUKE_SITE = $(call github,Texas-Lupo,fluke,$(FLUKE_VERSION))

FLUKE_LICENSE = GPL-3.0
FLUKE_LICENSE_FILES = LICENSE

# TARGET_CONFIGURE_OPTS automatically passes the correct ARM cross-compiler, 
# as well as the -Os, -mcpu, and -mfloat-abi flags defined in your defconfig.
define FLUKE_BUILD_CMDS
	@echo "Building fluke for ARM target"
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

# Installs the compiled binary into the drone's /usr/bin directory and makes it executable
define FLUKE_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/fluke $(TARGET_DIR)/usr/bin/fluke
	$(INSTALL) -m 644 -t $(TARGET_DIR)/etc $(FLUKE_PKGDIR)/files/fluke.conf

endef

$(eval $(generic-package))
