include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = FastDel
FastDel_FILES = FDPrefs_RootListController.m
FastDel_INSTALL_PATH = /Library/PreferenceBundles
FastDel_FRAMEWORKS = UIKit
FastDel_PRIVATE_FRAMEWORKS = Preferences
FastDel_CFLAGS += -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/FastDel.plist$(ECHO_END)
