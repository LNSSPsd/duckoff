TARGET := iphone:clang:latest:7.0
ARCHS := arm64 arm64e
INSTALL_TARGET_PROCESSES = kbd


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = duckoff

duckoff_FILES = Tweak.c
duckoff_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk