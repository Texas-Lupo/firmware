################################################################################
#
# waybeam
#
################################################################################

# Replace with the actual commit hash or release tag and Github user/repo
WAYBEAM_VERSION = HEAD
WAYBEAM_SITE = $(call github,OpenIPC,waybeam_venc,$(WAYBEAM_VERSION))
WAYBEAM_LICENSE = GPL-3.0 # Update with actual license

# The Makefile supports 'star6e' (default) and 'maruko'
WAYBEAM_SOC ?= star6e

# Override the cross-compiler provided by the Makefile's internal toolchain downloader
# Ensure we build the main target, json_cli, and regscan as defined in the source
define WAYBEAM_BUILD_CMDS
	$(MAKE) CC="$(TARGET_CC)" \
		CFLAGS="$(TARGET_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS) -s" \
		SOC_BUILD=$(WAYBEAM_SOC) \
		-C $(@D) \
		build json_cli regscan
endef

# Install the built binaries from the SOC-specific output directory to the target[cite: 1, 2]
define WAYBEAM_INSTALL_TARGET_CMDS
	$(INSTALL) -m 755 -d $(TARGET_DIR)/usr/bin
	$(INSTALL) -m 755 -t $(TARGET_DIR)/usr/bin $(@D)/out/$(WAYBEAM_SOC)/waybeam
  $(INSTALL) -m 644 -t $(TARGET_DIR)/etc/ $(WAYBEAM_PKGDIR)/files/waybeam.json
	$(INSTALL) -m 755 -d $(TARGET_DIR)/etc/init.d
	$(INSTALL) -m 755 -t $(TARGET_DIR)/etc/init.d $(WAYBEAM_PKGDIR)/files/S99waybeam
	$(INSTALL) -m 755 -t $(TARGET_DIR)/usr/bin $(@D)/out/$(WAYBEAM_SOC)/json_cli
	$(INSTALL) -m 755 -t $(TARGET_DIR)/usr/bin $(@D)/out/$(WAYBEAM_SOC)/regscan
endef

$(eval $(generic-package))
