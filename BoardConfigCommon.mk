#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

DEVICE_COMMON_PATH := device/lge/g5-common

# inherit from common msm8996
-include device/lge/msm8996-common/BoardConfigCommon.mk

# Camera
TARGET_LD_SHIM_LIBS += \
    /system/vendor/lib/libbwfocuspeaking.so|/system/vendor/lib/libshim_bwfocus.so

# HIDL
DEVICE_MANIFEST_FILE += $(DEVICE_COMMON_PATH)/manifest.xml

# Kernel
TARGET_KERNEL_CONFIG += vendor/lge/lge_alice_common.config

# Lights
TARGET_PROVIDES_LIBLIGHT := true
# Partitions
BOARD_BOOTIMAGE_PARTITION_SIZE := 41943040
BOARD_PERSISTIMAGE_PARTITION_SIZE := 33554432
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 41943040

BOARD_PRODUCTIMAGE_MINIMAL_PARTITION_RESERVED_SIZE := true
-include vendor/lineage/config/BoardConfigReservedSize.mk
$(warning PRODUCT_RESERVED=$(BOARD_PRODUCTIMAGE_PARTITION_RESERVED_SIZE))

BOARD_SUPER_PARTITION_METADATA_DEVICE := system
BOARD_SUPER_PARTITION_GROUPS := qti_dynamic_partitions
BOARD_QTI_DYNAMIC_PARTITIONS_PARTITION_LIST := odm product system system_ext vendor
ifneq ($(filter h830,$(TARGET_DEVICE)),)
BOARD_CACHEIMAGE_PARTITION_SIZE := 1291845632
BOARD_SUPER_PARTITION_SIZE := 4831838208
BOARD_SUPER_PARTITION_SYSTEM_DEVICE_SIZE := 4831838208
BOARD_QTI_DYNAMIC_PARTITIONS_SIZE := 4827643904 # (BOARD_SUPER_PARTITION_SIZE - 4194304) 4MiB overhead
else ifneq ($(filter h850,$(TARGET_DEVICE)),)
BOARD_CACHEIMAGE_PARTITION_SIZE := 536870912
BOARD_SUPER_PARTITION_SIZE := 4148166656
BOARD_SUPER_PARTITION_SYSTEM_DEVICE_SIZE := 4148166656
BOARD_QTI_DYNAMIC_PARTITIONS_SIZE := 4143972352 # (BOARD_SUPER_PARTITION_SIZE - 4194304) 4MiB overhead
else
BOARD_CACHEIMAGE_PARTITION_SIZE := 2172649472
BOARD_SUPER_PARTITION_SIZE := 6064963584
BOARD_SUPER_PARTITION_SYSTEM_DEVICE_SIZE := 6064963584
BOARD_QTI_DYNAMIC_PARTITIONS_SIZE := 6060769280 # (BOARD_SUPER_PARTITION_SIZE - 4194304) 4MiB overhead
endif

ALL_PARTITIONS := product system system_ext odm vendor
$(foreach p, $(call to-upper, $(ALL_PARTITIONS)), \
    $(eval BOARD_$(p)IMAGE_FILE_SYSTEM_TYPE := ext4) \
    $(eval TARGET_COPY_OUT_$(p) := $(call to-lower, $(p))))


# SELinux policies
BOARD_VENDOR_SEPOLICY_DIRS += $(DEVICE_COMMON_PATH)/sepolicy/vendor

# inherit from the proprietary version
include vendor/lge/g5-common/BoardConfigVendor.mk
