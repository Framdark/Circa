GO_EASY_ON_ME = 1

include theos/makefiles/common.mk

TARGET = simulator:clang

TWEAK_NAME = Circa
Circa_FRAMEWORKS = UIKit QuartzCore
Circa_FILES = Tweak.xm

SUBPROJECTS = circaprefs

ARCH = Arm64 Arm64E

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "killall -9 SpringBoard"
