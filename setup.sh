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
    ["device/nothing/Pong"]="https://github.com/Pong-Development/device_nothing_Pong.git|17"
    ["vendor/nothing/Pong"]="https://github.com/Pong-Development/vendor_nothing_Pong.git|17"
    ["kernel/nothing/sm8475"]="https://github.com/Pong-Development/kernel_nothing_sm8475.git|test"
    ["kernel/nothing/sm8475-modules"]="https://github.com/Pong-Development/kernel_nothing_sm8475-modules.git|test"
    ["kernel/nothing/sm8475-devicetrees"]="https://github.com/Nothing-phone-2-Development/android_kernel_nothing_sm8475-devicetrees.git|lineage-23.0"
    ["hardware/qcom-caf/sm8450/display"]="https://github.com/Pong-Development/hardware_qcom-caf_sm8450_display.git|16.2"
    ["packages/apps/ParanoidGlyphPhone2"]="https://github.com/Pong-Development/packages_apps_ParanoidGlyph.git|17"
    ["packages/apps/GlyphAdapter"]="https://github.com/Pong-Development/packages_apps_GlyphAdapter.git|16"
    ["hardware/dolby"]="https://github.com/Pong-Development/hardware_dolby.git|16"
)

# Function to clone a repository with error handling
clone_repo() {
    local target_dir="$1"
    local repo_data="$2"

    IFS='|' read -r repo_url branch <<< "$repo_data"

    echo "Cloning $target_dir..."
    echo "Repository: $repo_url"
    echo "Branch: $branch"

    rm -rf "$target_dir"

    if git clone $CLONE_DEPTH -b "$branch" "$repo_url" "$target_dir"; then
        echo ""
        echo "✅ Successfully cloned ✨ $target_dir"
        echo "🌿 Branch: $branch"
        echo ""
    else
        echo ""
        echo "❌ Failed to clone $target_dir"
        echo "🌿 Branch: $branch"
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
