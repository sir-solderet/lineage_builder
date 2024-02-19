#!/bin/bash

set -e

# Initialize repo with specified manifest
repo init -u https://github.com/LineageOS/android.git -b lineage-21.0 --git-lfs
crave push patches
crave push RisingOS.mk device/phh/treble
# Run inside foss.crave.io devspace, in the project folder
# Remove existing local_manifests
crave run --clean -- "rm -rf .repo/local_manifests && \
# Initialize repo with specified manifest
repo init -u https://github.com/RisingTechOSS/android -b fourteen --git-lfs ;\

# Clone local_manifests repository
git clone https://github.com/Shirayuki39/treble_manifest.git .repo/local_manifests -b 14 ;\

# Removals
# rm -rf system/libhidl prebuilts/clang/host/linux-x86 prebuilt/*/webview.apk platform/external/python/pyfakefs platform/external/python/bumble external/chromium-webview/prebuilt/x86_64 platform/external/opencensus-java && \

# Sync the repositories
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags && \ 

bash patches/apply-patches.sh . && \

# Set up build environment
cd device/phh/treble
bash generate.sh RisingOS+GApps && \

source build/envsetup.sh && \

# Lunch configuration
lunch treble_arm64_bgN-userdebug ;\

croot ;\
make systemimage -j$(nproc --all) ; \
echo "Date and time:" ; \

# Print out/build_date.txt
cat out/build_date.txt; \

# Print SHA256
sha256sum out/target/product/*/*.img"

# Clean up
# rm -rf tissot/*

# Pull generated zip files
# crave pull out/target/product/*/*.zip 

Pull generated img files
crave pull out/target/product/*/*.img

# Upload zips to Telegram
# telegram-upload --to sdreleases tissot/*.zip

#Upload to Github Releases
#curl -sf https://raw.githubusercontent.com/Meghthedev/Releases/main/headless.sh | sh
