#!/bin/bash

# Welcome message
echo ""
echo " ███╗   ██╗ ██████╗ ████████╗██╗  ██╗██╗███╗   ██╗ ██████╗     ██████╗ ██╗  ██╗ ██████╗ ███╗   ██╗███████╗    ██████╗  "
echo " ████╗  ██║██╔═══██╗╚══██╔══╝██║  ██║██║████╗  ██║██╔════╝     ██╔══██╗██║  ██║██╔═══██╗████╗  ██║██╔════╝    ╚════██╗ "
echo " ██╔██╗ ██║██║   ██║   ██║   ███████║██║██╔██╗ ██║██║  ███╗    ██████╔╝███████║██║   ██║██╔██╗ ██║█████╗       █████╔╝ "
echo " ██║╚██╗██║██║   ██║   ██║   ██╔══██║██║██║╚██╗██║██║   ██║    ██╔═══╝ ██╔══██║██║   ██║██║╚██╗██║██╔══╝      ██╔═══╝  "
echo " ██║ ╚████║╚██████╔╝   ██║   ██║  ██║██║██║ ╚████║╚██████╔╝    ██║     ██║  ██║╚██████╔╝██║ ╚████║███████╗    ███████╗ "
echo " ╚═╝  ╚═══╝ ╚═════╝    ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝     ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝    ╚══════╝ "
echo ""

echo "=========================================================================="
echo "   Welcome to the Custom ROM Cloning Script for Nothing Phone 2 (Pong)!   "
echo "=========================================================================="
echo ""
echo "✨ Happy custom ROM building! ✨"
echo ""
echo "🔧 Build script by: GHOST | ゴースト"
echo ""

# Explain Depth Cloning
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📌 Git Depth Cloning Explanation:"
echo ""
echo "   - **Shallow Clone (--depth=1)**: Only fetches the latest commit, making cloning faster and saving space."
echo "   - **Full Clone**: Fetches the entire repository history, useful for development but slower."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Ask user whether to use depth cloning
echo ""
read -p "Do you want to use depth cloning (--depth=1) for faster cloning? (y/n): " DEPTH_CHOICE
if [[ "$DEPTH_CHOICE" =~ ^[Yy]$ ]]; then
    CLONE_DEPTH="--depth=1"
    echo ""
    echo "✅ Using shallow clone (--depth=1) for faster setup."
    echo ""
else
    CLONE_DEPTH=""
    echo ""
    echo "✅ Using full repository clone."
    echo ""
fi

# Define repositories
declare -A REPOS=(
    ["device/nothing/Pong"]="https://github.com/Pong-Development/device_nothing_Pong.git"
    ["vendor/nothing/Pong"]="https://github.com/Pong-Development/vendor_nothing_Pong.git"
    ["kernel/nothing/sm8475"]="https://github.com/Pong-Development/kernel_nothing_sm8475.git"
    ["hardware/qcom-caf/sm8450/display"]="https://github.com/Pong-Development/hardware_qcom-caf_sm8450_display.git"
    ["hardware/qcom-caf/sm8450/audio/primary-hal"]="https://github.com/Pong-Development/hardware_qcom_audio-ar.git"
    ["hardware/qcom-caf/sm8450/audio/pal"]="https://github.com/Pong-Development/vendor_qcom_opensource_arpal-lx.git"
    ["hardware/qcom-caf/sm8450/audio/agm"]="https://github.com/Pong-Development/vendor_qcom_opensource_agm.git"
    ["hardware/qcom-caf/sm8450/audio/graphservices"]="https://github.com/Pong-Development/vendor_qcom_opensource_audioreach-graphservices.git"
    ["packages/apps/ParanoidGlyphPhone2"]="https://github.com/Pong-Development/packages_apps_ParanoidGlyph.git"
    ["packages/apps/GlyphAdapter"]="https://github.com/Pong-Development/packages_apps_GlyphAdapter.git"
    ["hardware/dolby"]="https://github.com/Pong-Development/hardware_dolby.git"
)

# Function to clone a repository with error handling
clone_repo() {
    local target_dir="$1"
    local repo_url="$2"
    
    echo "Cloning $target_dir..."
    
    # Remove existing directory if it exists
    rm -rf "$target_dir"
    
    if git clone $CLONE_DEPTH "$repo_url" "$target_dir"; then
        echo ""
        echo "✅ Successfully cloned ✨ $target_dir"
        echo ""
    else
        echo ""
        echo "❌ Failed to clone $target_dir. Check your internet connection."
        echo ""
        exit 1
    fi
}

# Override host metadata for reproducible builds
read -p "Do you want to override BUILD_USERNAME and BUILD_HOSTNAME? (y/n): " OVERRIDE_CHOICE
if [[ "$OVERRIDE_CHOICE" =~ ^[Yy]$ ]]; then
    read -p "Enter your desired BUILD_USERNAME: " BUILD_USERNAME
    read -p "Enter your desired BUILD_HOSTNAME: " BUILD_HOSTNAME
    
    export BUILD_USERNAME="$BUILD_USERNAME"
    export BUILD_HOSTNAME="$BUILD_HOSTNAME"
    
    echo ""
    echo "BUILD_USERNAME is set to: $BUILD_USERNAME"
    echo "BUILD_HOSTNAME is set to: $BUILD_HOSTNAME"
    echo ""
else
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Using default BUILD_USERNAME and BUILD_HOSTNAME"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
fi

# Clone repositories
for target_dir in "${!REPOS[@]}"; do
    clone_repo "$target_dir" "${REPOS[$target_dir]}"
done

# KernelSU patch
echo "Applying KernelSU patch..."
cd kernel/nothing/sm8475 || exit 1
curl -LSs "https://raw.githubusercontent.com/tiann/KernelSU/main/kernel/setup.sh" | bash -s v2.0.0
cd - >/dev/null
echo ""
echo ""
echo " ✅ KernelSU patch applied."
echo ""

# setup done
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " ✅ Setup completed successfully! "
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

echo ""
echo "🚀 All repositories have been cloned successfully!"
echo ""
echo "🎉 Enjoy building your custom ROM!"

echo ""
echo "✨ Done! Happy flashing! ✨"
echo ""
