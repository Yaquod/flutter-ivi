# Yocto Integration for NVIDIA Orin

This document describes how to cross-compile and deploy the Robotaxi IVI stack (flutter_ivi + ivi-homescreen + filament_scene) on an **NVIDIA Jetson Orin** target using the Yocto/OpenEmbedded build system.

---

## Layer Dependencies

| Layer | URI | Branch |
|-------|-----|--------|
| `meta-tegra` | https://github.com/OE4T/meta-tegra | `scarthgap` |
| `meta-flutter` | https://github.com/meta-flutter/meta-flutter | `scarthgap` |
| `meta-openembedded` | https://github.com/openembedded/meta-openembedded | `scarthgap` |
| `meta-ivi-homescreen` | (TBD — ivi-homescreen Yocto layer) | — |
| `meta-robotaxi` | *(custom layer for this project)* | — |

---

## Layer: `meta-robotaxi`

Create a custom layer with the following recipe structure:

```
meta-robotaxi/
  recipes-robotaxi/
    flutter-ivi/
      flutter-ivi_git.bbappend   (or .bb)
    filament/
      filament_git.bb
```

### Recipe: Filament (v1.65.2)

```bitbake
SUMMARY = "Google Filament 3D rendering engine"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=3b83ef96387f14655fc854ddc3c6bd57"
SRC_URI = "git://github.com/google/filament.git;branch=main;protocol=https"
SRCREV = "<commit-hash>"

S = "${WORKDIR}/git"

inherit cmake

PACKAGECONFIG ??= "vulkan wayland"
PACKAGECONFIG[vulkan] = "-DFILAMENT_SUPPORTS_VULKAN=ON,-DFILAMENT_SUPPORTS_VULKAN=OFF,vulkan-headers"
PACKAGECONFIG[wayland] = "-DFILAMENT_SUPPORTS_WAYLAND=ON,-DFILAMENT_SUPPORTS_WAYLAND=OFF,wayland"

EXTRA_OECMAKE = " \
    -DCMAKE_BUILD_TYPE=Release \
    -DFILAMENT_SUPPORTS_XLIB=OFF \
    -DFILAMENT_SUPPORTS_XCB=OFF \
    -DFILAMENT_SUPPORTS_OPENGL=OFF \
    -DFILAMENT_ENABLE_CIVETWEB=OFF \
"

do_install() {
    install -d ${D}${libdir}
    # Install only the runtime libraries needed by filament_scene
    for lib in libbackend.a libbluevk.a libfilament.a libfilabridge.a \
               libvkshaders.a libutils.a libgeometry.a libibl.a \
               libuberarchive.a libgltfio_core.a libgltfio.a libcamutils.a; do
        install -m 0644 ${B}/release/${lib} ${D}${libdir}/
    done
    # Header files
    cp -r ${S}/include ${D}${includedir}/filament
}
```

### Recipe: flutter-ivi

The existing `flutter-ivi_git.bb` from `meta-flutter` needs a `.bbappend` to add:

```bitbake
# flutter-ivi_git.bbappend
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    git://github.com/Yaquod/flutter-ivi.git;branch=main;name=app;destsuffix=app \
"

S = "${WORKDIR}/app"

# Add Filament plugin dependency
DEPENDS += "filament ivi-homescreen-plugins"

do_configure:append() {
    # Symlink the filament_scene plugin from ivi-homescreen-plugins
    ln -sf ${WORKDIR}/ivi-homescreen-plugins/plugins/filament_view \
        ${S}/plugins/filament_view
}

do_compile:append() {
    # Build Flutter app with embedded Linux target
    flutter build bundle \
        --target-platform linux-arm64 \
        --release
}
```

---

## Build Configuration (`local.conf`)

```bitbake
MACHINE = "jetson-orin-nx-devkit"  # or jetson-agx-orin-devkit

# Required distro features
DISTRO_FEATURES:append = " vulkan wayland opengl"

# NVIDIA BSP driver
PREFERRED_PROVIDER_virtual/egl = "tegra-libraries-egl"
PREFERRED_PROVIDER_virtual/libgles2 = "tegra-libraries-gles2"
PREFERRED_PROVIDER_virtual/libgl = "tegra-libraries-gl"

# Kernel modules
MACHINE_ESSENTIAL_EXTRA_RDEPENDS += "kernel-module-nvgpu kernel-module-tegra"

# Flutter
IMAGE_INSTALL:append = " flutter-ivi ivi-homescreen flutter-engine"

# Filament
IMAGE_INSTALL:append = " filament"

# Wayland
IMAGE_INSTALL:append = " weston"
```

---

## Cross-Compilation Notes

### CMake Toolchain

Orin is `aarch64`. The Yocto SDK provides the cross-compiler. Key CMake vars:

```
CMAKE_SYSTEM_NAME=Linux
CMAKE_SYSTEM_PROCESSOR=aarch64
CMAKE_C_COMPILER=aarch64-poky-linux-gcc
CMAKE_CXX_COMPILER=aarch64-poky-linux-g++
```

### Vulkan on Orin

The Orin GPU driver is **proprietary NVIDIA** (`nvgpu` kernel module). Vulkan 1.3 is supported natively — no `llvmpipe` fallback. Make sure:

- `CONFIG_TEGRA_NVGPU` is enabled in kernel
- `vkms` / `msm` / `llvmpipe` are **not** loaded
- `libvulkan.so` from NVIDIA BSP provides the ICD

### Filament Vulkan + Wayland

The `filament_scene` plugin hardcodes `Backend::VULKAN` and passes a `{wl_display*, wl_surface*, width, height}` native window struct. On Orin with `FILAMENT_SUPPORTS_WAYLAND=ON`, Filament's `VulkanPlatformLinuxWindows.cpp` creates a `VkSurfaceKHR` from the Wayland surface — this path works correctly with the NVIDIA proprietary driver.

---

## Flashing / Deployment

```bash
# Build the full image
bitbake core-image-weston

# Flash to Orin (via SDK Manager or dd)
# Or deploy via ostree / swupdate
```

For development iteration:

```bash
# Build individual packages
bitbake flutter-ivi -c compile -f
bitbake filament
bitbake ivi-homescreen

# Copy artifacts via scp to running Orin:
scp tmp/work/aarch64-poky-linux/flutter-ivi/git/build/flutter_assets/* \
    root@orin:/opt/homescreen/data/flutter_assets/
```

---

## Runtime Launch

```bash
# On the Orin target:
export WAYLAND_DISPLAY=wayland-0
export GDK_BACKEND=wayland
export XDG_RUNTIME_DIR=/run/user/0

/home/root/homescreen \
    -b /opt/homescreen \
    -w 1920 -h 1080 \
    --fullscreen
```

The `filament_scene` plugin creates a `wl_subsurface` placed **above** the Flutter surface at the position specified by the Dart `SceneView` widget layout. With the NVIDIA Vulkan driver, subsurface composition works correctly.

---

## Known Issues

| Issue | Status | Workaround |
|-------|--------|------------|
| Desktop llvmpipe: 3D viewport invisible | Will not fix | Only affects llvmpipe; Orin with real GPU works |
| `[E] handleMessage: Message type not found` | Cosmetic | ECS routing mismatch, does not affect rendering |
| Flutter bundle symlink | Dev-only | `ln -sf build/flutter_assets .desktop-homescreen/data/flutter_assets/` |
