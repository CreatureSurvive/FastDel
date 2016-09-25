ARCHS = armv7 arm64
GO_EASY_ON_ME=1
TARGET = iphone:clang:9.2:latest

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = FastDel
FastDel_FILES = Tweak.xm
FastDel_FRAMEWORKS = UIKit
ADDITIONAL_OBJCFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"

SUBPROJECTS += fdprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
