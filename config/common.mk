# Allow vendor/extra to override any property by setting it first
$(call inherit-product-if-exists, vendor/extra/product.mk)
$(call inherit-product-if-exists, vendor/pixel-framework/config.mk)
$(call inherit-product-if-exists, vendor/certification/config.mk)
$(call inherit-product-if-exists, vendor/microsoft/packages.mk)

PRODUCT_BRAND ?= EvolutionX

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_SYSTEM_PROPERTIES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_SYSTEM_PROPERTIES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

# Gboard configuration
PRODUCT_PRODUCT_PROPERTIES += \
    ro.com.google.ime.theme_id=5 \
    ro.com.google.ime.system_lm_dir=/product/usr/share/ime/google/d3_lms

# SetupWizard configuration
PRODUCT_PRODUCT_PROPERTIES += \
    ro.setupwizard.enterprise_mode=1 \
    ro.setupwizard.esim_cid_ignore=00000001 \
    setupwizard.enable_assist_gesture_training=true \
    setupwizard.theme=glif_v4_light \
    setupwizard.feature.baseline_setupwizard_enabled=true \
    setupwizard.feature.skip_button_use_mobile_data.carrier1839=true \
    setupwizard.feature.show_pai_screen_in_main_flow.carrier1839=false \
    setupwizard.feature.show_pixel_tos=false

ifeq ($(PRODUCT_CHARACTERISTICS),tablet)
PRODUCT_PRODUCT_PROPERTIES += ro.setupwizard.rotation_locked=false
else
PRODUCT_PRODUCT_PROPERTIES += ro.setupwizard.rotation_locked=true
endif

# StorageManager configuration
PRODUCT_PRODUCT_PROPERTIES += \
    ro.storage_manager.show_opt_in=false

# OPA configuration
PRODUCT_PRODUCT_PROPERTIES += \
    ro.opa.eligible_device=true

# Google Play services configuration
PRODUCT_PRODUCT_PROPERTIES += \
    ro.error.receiver.system.apps=com.google.android.gms \
    ro.atrace.core.services=com.google.android.gms,com.google.android.gms.ui,com.google.android.gms.persistent

# CarrierSetup configuration
PRODUCT_PRODUCT_PROPERTIES += \
    ro.carriersetup.vzw_consent_page=true

# BtHelper
PRODUCT_PACKAGES += \
    BtHelper

# Use gestures by default
PRODUCT_PROPERTY_OVERRIDES += \
    ro.boot.vendor.overlay.theme=com.android.internal.systemui.navbar.gestural;com.google.android.systemui.gxoverlay

# Sensors
PRODUCT_PACKAGES += \
    android.frameworks.sensorservice@1.0.vendor

# DRM Service
PRODUCT_PROPERTY_OVERRIDES += \
    drm.service.enabled=true \
    media.mediadrmservice.enable=true

ifeq ($(TARGET_BUILD_VARIANT),eng)
# Disable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=0
else
# Enable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=1

# Disable extra StrictMode features on all non-engineering builds
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += persist.sys.strictmode.disable=true
endif

ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_SYSTEM_PROPERTIES += \
    ro.ota.allow_downgrade=true
endif

# Disable async MTE on system_server
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    persist.arm64.memtag.system_server=off

# Blur
TARGET_ENABLE_BLUR ?= false
ifeq ($(TARGET_ENABLE_BLUR), true)
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.sf.blurs_are_expensive=1 \
    ro.surface_flinger.supports_background_blur=1
else
PRODUCT_SYSTEM_PROPERTIES += \
    ro.launcher.blur.appLaunch=0
endif

# Enable SystemUIDialog volume panel
PRODUCT_SYSTEM_PROPERTIES += \
    sys.fflag.override.settings_volume_panel_in_systemui=true

# Evolution X-specific broadcast actions whitelist
PRODUCT_COPY_FILES += \
    vendor/evolution/config/permissions/evolution-sysconfig.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/evolution-sysconfig.xml

# Evolution X-specific init rc file
PRODUCT_COPY_FILES += \
    vendor/evolution/prebuilt/common/etc/init/init.evolution-system_ext.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/init.evolution-system_ext.rc

# Copy all Evolution X-specific init rc files
PRODUCT_COPY_FILES += \
    vendor/evolution/prebuilt/common/etc/init/init.evolution-x-updater.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/init.evolution-x-updater.rc

# LineageHW permission
PRODUCT_COPY_FILES += \
    vendor/evolution/config/permissions/privapp-permissions-lineagehw.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-lineagehw.xml

# Permissions for lineage sdk services
PRODUCT_COPY_FILES += \
    vendor/evolution/config/permissions/org.lineageos.health.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/org.lineageos.health.xml \
    vendor/evolution/config/permissions/org.lineageos.livedisplay.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/org.lineageos.livedisplay.xml

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/android.software.sip.voip.xml

# Keylayout
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:$(TARGET_COPY_OUT_PRODUCT)/usr/keylayout/Vendor_045e_Product_0719.kl \
    vendor/evolution/misc/keylayout/Vendor_2dc8_Product_6006.kl:$(TARGET_COPY_OUT_PRODUCT)/usr/keylayout/Vendor_2dc8_Product_6006.kl

# Enable transitional log for Privileged permissions
PRODUCT_SYSTEM_PROPERTIES += \
    ro.control_privapp_permissions=log

# Protobuf - Workaround for prebuilt Qualcomm HAL
PRODUCT_PACKAGES += \
    libprotobuf-cpp-full-3.9.1-vendorcompat \
    libprotobuf-cpp-lite-3.9.1-vendorcompat

# Clean up packages cache to avoid wrong strings and resources
PRODUCT_COPY_FILES += \
    vendor/evolution/prebuilt/common/bin/clean_cache.sh:system/bin/clean_cache.sh

# Support many users/work profiles
PRODUCT_SYSTEM_PROPERTIES += \
    persist.sys.max_profiles=16 \
    fw.max_users=32

# Don't build debug for host or device
ifeq ($(TARGET_BUILD_VARIANT), user)
PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true
PRODUCT_SYSTEM_SERVER_DEBUG_INFO := false
WITH_DEXPREOPT_DEBUG_INFO := false
ART_BUILD_TARGET_NDEBUG := false
ART_BUILD_TARGET_DEBUG := false
ART_BUILD_HOST_NDEBUG := false
ART_BUILD_HOST_DEBUG := false
USE_DEX2OAT_DEBUG := false
endif

# Disable debug infos
ifeq ($(TARGET_BUILD_VARIANT), user)
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    dalvik.vm.dex2oat-minidebuginfo=false
endif

# Enable whole-program R8 Java optimizations for SystemUI and system_server,
# but also allow explicit overriding for testing and development.
SYSTEM_OPTIMIZE_JAVA ?= true
SYSTEMUI_OPTIMIZE_JAVA ?= true

# Relax Broken Library Check
PRODUCT_BROKEN_VERIFY_USES_LIBRARIES := true

# Disable vendor restrictions
PRODUCT_RESTRICT_VENDOR_FILES := false

# Charger
PRODUCT_PACKAGES += \
    product_charger_res_images \
    product_charger_res_images_vendor

# Filesystems tools
PRODUCT_PACKAGES += \
    fsck.ntfs \
    mkfs.ntfs \
    mount.ntfs

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/fsck.ntfs \
    system/bin/mkfs.ntfs \
    system/bin/mount.ntfs \
    system/%/libfuse-lite.so \
    system/%/libntfs-3g.so

# rsync
PRODUCT_PACKAGES += \
    rsync

# Extra cmdline tools
PRODUCT_PACKAGES += \
    unrar \
    zstd

# Evolution X customization
TARGET_USES_LEGACY_BOOTANIMATION ?= false
TARGET_SUPPORTS_QUICK_TAP ?= false

# Gapps flags
TARGET_USES_MINI_GAPPS ?= false
TARGET_USES_PICO_GAPPS ?= false

# Pixel-specific flags
TARGET_IS_PIXEL ?= false
ifneq ($(filter $(EVOLUTION_BUILD),$(shell cat vendor/evolution/vars/pixels | grep '  ')),)
TARGET_IS_PIXEL := true
endif

ifeq ($(TARGET_IS_PIXEL),true)
DISABLE_ARTIFACT_PATH_REQUIREMENTS := true
PRODUCT_USE_SCUDO := true
endif

TARGET_IS_PIXEL_6 ?= false
TARGET_IS_PIXEL_7 ?= false
TARGET_IS_PIXEL_7A ?= false
TARGET_IS_PIXEL_8 ?= false
TARGET_IS_PIXEL_FOLD ?= false
TARGET_IS_PIXEL_TABLET ?= false
TARGET_PIXEL_STAND_SUPPORTED ?= false

# Face Unlock
ifeq ($(TARGET_SUPPORTS_64_BIT_APPS),true)
PRODUCT_PACKAGES += \
    ParanoidSense

PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.face.sense_service=true

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.biometrics.face.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.hardware.biometrics.face.xml
endif

# Dex preopt
PRODUCT_DEXPREOPT_SPEED_APPS += \
    NexusLauncherRelease

# Don't compile SystemUITests
EXCLUDE_SYSTEMUI_TESTS := true

# SystemUI
PRODUCT_SYSTEM_PROPERTIES += \
    dalvik.vm.systemuicompilerfilter=speed

# Disable touch video heatmap to reduce latency, motion jitter, and CPU usage
# on supported devices with Deep Press input classifier HALs and models
PRODUCT_PRODUCT_PROPERTIES += \
    ro.input.video_enabled=false

# Workaround AOSP AM crash
PRODUCT_PROPERTY_OVERRIDES += \
    sys.fflag.override.settings_enable_monitor_phantom_procs=false

# Overlay
PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/evolution/overlay
PRODUCT_PACKAGE_OVERLAYS += \
    vendor/evolution/overlay/common

# Anything including updatable_apex.mk should have done so by now.
ifeq ($(TARGET_FLATTEN_APEX), false)
$(call inherit-product-if-exists, vendor/partner_modules/build/mainline_modules.mk)
else
$(call inherit-product-if-exists, vendor/partner_modules/build/mainline_modules_flatten_apex.mk)
endif

# Inherit from audio config
$(call inherit-product-if-exists, frameworks/base/data/sounds/AudioPackage14.mk)
$(call inherit-product, vendor/evolution/config/audio.mk)

# Inherit from bootanimation config
ifeq ($(TARGET_IS_PIXEL), true)
$(call inherit-product, vendor/evolution/config/bootanimation_pixels.mk)
else ifneq ($(TARGET_USES_LEGACY_BOOTANIMATION), true)
$(call inherit-product, vendor/evolution/config/bootanimation.mk)
endif

# Inherit from clocks config
$(call inherit-product, vendor/evolution/config/clocks.mk)

# Inherit from fonts config
$(call inherit-product, vendor/evolution/config/fonts.mk)

# Inherit from gfonts config
$(call inherit-product, vendor/evolution/config/gfonts.mk)

# Inherit from packages config
$(call inherit-product, vendor/evolution/config/packages.mk)

# Inherit from rro_overlays config
$(call inherit-product, vendor/evolution/config/rro_overlays.mk)

# Inherit from textclassifier config
$(call inherit-product, vendor/evolution/config/textclassifier.mk)

# Inherit from themes config
$(call inherit-product, vendor/evolution/config/themes.mk)

# Inherit from version config
$(call inherit-product, vendor/evolution/config/version.mk)

-include $(WORKSPACE)/build_env/image-auto-bits.mk
