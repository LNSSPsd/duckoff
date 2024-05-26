TARGET := iphone:clang:latest:13.0
ARCHS := arm64 arm64e
INSTALL_TARGET_PROCESSES = kbd


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = duckoff

duckoff_CFLAGS = -fobjc-arc
ifeq ($(THEOS_PACKAGE_SCHEME),rootless)
	duckoff_CFLAGS += -DIS_ROOTLESS=1
endif

duckoff_FILES = Tweak.m
duckoff_FRAMEWORKS = CydiaSubstrate

include $(THEOS_MAKE_PATH)/tweak.mk
