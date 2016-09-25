include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = fdprefs
fdprefs_FILES = FDPRootListController.m
fdprefs_INSTALL_PATH = /Library/PreferenceBundles
fdprefs_FRAMEWORKS = UIKit
fdprefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/fdprefs.plist$(ECHO_END)
