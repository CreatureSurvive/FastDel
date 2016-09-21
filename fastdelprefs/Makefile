ARCHS = armv7 arm64
GO_EASY_ON_ME=1
TARGET = iphone:clang:9.2:latest

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = fastdelprefs
fastdelprefs_FILES = fastdelprefsListController.mm
fastdelprefs_INSTALL_PATH = /Library/PreferenceBundles
fastdelprefs_FRAMEWORKS = UIKit
fastdelprefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/fastdel.plist$(ECHO_END)
