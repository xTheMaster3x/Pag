DEBUG = 0
ARCHS = armv7 arm64
TARGET = iphone:clang:latest:latest
THEOS_BUILD_DIR = Packages

include theos/makefiles/common.mk

TWEAK_NAME = Pag
Pag_FILES = Tweak.xm
Pag_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 MobileSafari"
#SUBPROJECTS += pag
#include $(THEOS_MAKE_PATH)/aggregate.mk
