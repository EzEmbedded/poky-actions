#!/bin/bash
git clone --depth 1 git://git.yoctoproject.org/poky -b hardknott  poky
git clone https://github.com/superna9999/meta-meson.git meta-meson -b hardknott 
git clone git://git.openembedded.org/meta-openembedded -b hardknott 
git clone git://git.yoctoproject.org/meta-virtualization -b hardknott 
# git clone git://git.openembedded.org/meta-perl -b hardknott
git clone git://git.yoctoproject.org/meta-security -b hardknott 
git clone git://github.com/kraj/meta-clang -b hardknott  
# git clone git://git.openembedded.org/meta-python2 -b thud  
# git clone https://github.com/OSSystems/meta-browser.git -b thud 
# git clone https://github.com/EzEmbedded/meta-kodi.git -b thud 
# git clone git://github.com/kraj/meta-openwrt.git -b thud 
# git clone -b gatesgarth git://git.openembedded.org/meta-openembedded
# git clone -b gatesgarth git://git.yoctoproject.org/meta-raspberrypi
# git clone -b gatesgarth https://github.com/meta-qt5/meta-qt5
pwd 
ls -al
source poky/oe-init-build-env # in build dir
pwd

bitbake-layers add-layer ../meta-openembedded/meta-oe/
bitbake-layers add-layer ../meta-openembedded/meta-python/
bitbake-layers add-layer ../meta-openembedded/meta-perl/
# bitbake-layers add-layer ../meta-openembedded/meta-multimedia/
bitbake-layers add-layer ../meta-openembedded/meta-networking/
bitbake-layers add-layer ../meta-openembedded/meta-filesystems/	
bitbake-layers add-layer ../meta-openembedded/meta-webserver/	 # cockpit 
bitbake-layers add-layer ../meta-virtualization/
bitbake-layers add-layer ../meta-security/	
# bitbake-layers add-layer ../meta-kodi/	
bitbake-layers add-layer ../meta-meson/
# bitbake-layers add-layer ../meta-clang/
# bitbake-layers add-layer ../meta-python2/
# bitbake-layers add-layer ../meta-browser/meta-chromium/
# bitbake-layers add-layer ../meta-openwrt/
# bitbake-layers show-layers

# bitbake-layers add-layer ../meta-raspberrypi
# bitbake-layers add-layer ../meta-qt5

# modify local.conf to build raspberrypi3 64-bit system
sed -i '/^MACHINE/s/= .*$/= "khadas-vim3l"/g' conf/local.conf
sed -i '/^#SDKMA/s/#\(.*\)=.*$/\1= "x86_64"/g'  conf/local.conf
sed -i '$a\BB_GENERATE_MIRROR_TARBALLS = "1"'  conf/local.conf 
sed -i '$a\INHERIT += "buildhistory"'  conf/local.conf
sed -i '$a\BUILDHISTORY_COMMIT = "1"'  conf/local.conf
# sed -i '$a\BB_NUMBER_THREADS = "2"'  conf/local.conf 
# sed -i '$a\PARALLEL_MAKE = "-j 2"'  conf/local.conf
# sed -i '$a\PACKAGECONFIG_append_pn-chromium = " component-build proprietary-codecs use-vaapi"'  conf/local.conf

# sed -i '$a\PACKAGECONFIG_append_pn-gstreamer1.0-plugins-good = "vpx wavpack libv4l2"'  conf/local.conf
sed -i '$a\LICENSE_FLAGS_WHITELIST += " commercial_mpg123 commercial commercial_libav commercial_x264 commercial"'  conf/local.conf
# systemd pam procd 
sed -i '$a\DISTRO_FEATURES_append = " virtualization systemd"'  conf/local.conf # cockpit---pam  podman---virtualization podman---systemd

sed -i '$a\INHERIT += "rm_work"'  conf/local.conf
# podman---podman podman-compose crun cgroup-lite ca-certificates python3-setuptools python3-pyyaml python3-json
# docker-ce cockpit podman podman-compose crun cgroup-lite rng-tools procps ca-certificates python3-setuptools python3-pyyaml python3-json
# bash docker-ce docker-ce-contrib python3 python3-docker-compose
sed -i '$a\IMAGE_INSTALL_append += " bash podman podman-compose crun cgroup-lite ca-certificates python3-setuptools python3-pyyaml python3-json"'  conf/local.conf

cat conf/local.conf
cat conf/bblayers.conf


#sed -i '/SDKMACHINE/aTOOLCHAIN_TARGET_TASK_append = "libc-staticdev"' conf/local.conf
#sed -i '/qt5-ptest/aPACKAGECONFIG_remove = "tslib"' ../meta-qt5/recipes-qt/qt5/qtbase_git.bb

# building image
#bitbake core-image-base
#bitbake qtbase
#bitbake core-image-base -c populate_sdk
# buildhistory-collect-srcrevs -a
# bitbake amlogic-image-headless-initrd --runonly=fetch # amlogic-image-headless-initrd/amlogic-image-headless-sd/amlogic-image-sato
# bitbake chromium --runonly=fetch
# bitbake amlogic-image-headless-sd  --runonly=fetch 
# bitbake amlogic-image-headless-sd -c populate_sdk_ext --runonly=fetch
# bitbake openwrt-image-full  -c populate_sdk_ext --runonly=fetch #openwrt-image-base/openwrt-image-full
bitbake amlogic-image-headless-initrd  # --runonly=fetch
buildhistory-collect-srcrevs -a > collect-srcrevs.txt