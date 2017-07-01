# @Author: Dana Buehre <creaturesurvive>
# @Date:   28-01-2017 12:51:15
# @Email:  dbuehre@me.com
# @Project: motuumLS
# @Filename: Makefile
# @Last modified by:   creaturesurvive
# @Last modified time: 01-07-2017 2:12:07
# @Copyright: Copyright © 2014-2017 CreatureSurvive


include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = FastDel
FastDel_FILES = FDPrefs_RootListController.m
FastDel_INSTALL_PATH = /Library/PreferenceBundles
FastDel_FRAMEWORKS = UIKit
FastDel_PRIVATE_FRAMEWORKS = Preferences SafariServices
FastDel_CFLAGS += -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/FastDel.plist$(ECHO_END)
