ARCHS = armv7 arm64
GO_EASY_ON_ME=1
TARGET = iphone:clang:latest:latest

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = FastDel
FastDel_FILES = Tweak.xm
# ADDITIONAL_OBJCFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += fastdelprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
