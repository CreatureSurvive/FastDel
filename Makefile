# @Author: Dana Buehre <creaturesurvive>
# @Date:   28-01-2017 12:51:15
# @Email:  dbuehre@me.com
# @Project: motuumLS
# @Filename: Makefile
# @Last modified by:   creaturesurvive
# @Last modified time: 01-07-2017 11:41:06
# @Copyright: Copyright © 2014-2017 CreatureSurvive


ARCHS = armv7 armv7s arm64
TARGET = iphone:clang:10.1:latest
THEOS_DEVICE_IP = 192.168.86.200
THEOS_DEVICE_PORT=22

GO_EASY_ON_ME=1
FINALPACKAGE = 1
DEBUG = 0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = FastDel
FastDel_FILES = Tweak.xm
FastDel_FRAMEWORKS = UIKit
ADDITIONAL_OBJCFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += fastdel
include $(THEOS_MAKE_PATH)/aggregate.mk
