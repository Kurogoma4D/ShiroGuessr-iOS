#!/bin/bash

# Script to help add localization files to Xcode project
# This script provides instructions since direct modification of .pbxproj can be fragile

set -e

echo "=================================================="
echo "ShiroGuessr Localization Setup"
echo "=================================================="
echo ""
echo "This script will guide you through adding localization files to your Xcode project."
echo ""
echo "The localization files are located at:"
echo "  - ShiroGuessr/Resources/Base.lproj/Localizable.strings"
echo "  - ShiroGuessr/Resources/ja.lproj/Localizable.strings"
echo ""
echo "Please follow these steps:"
echo ""
echo "METHOD 1: Add via Xcode (Recommended)"
echo "--------------------------------------"
echo "1. Open ShiroGuessr.xcodeproj in Xcode"
echo "2. In the Project Navigator, select the 'ShiroGuessr' project (blue icon)"
echo "3. Select the 'ShiroGuessr' target in the left sidebar"
echo "4. Go to the 'Info' tab"
echo "5. Under 'Localizations', click '+' to add Japanese (日本語)"
echo "6. In the dialog, check 'Localizable.strings' if it appears"
echo "7. Click 'Finish'"
echo "8. If the files don't appear, right-click 'ShiroGuessr' folder in Project Navigator"
echo "9. Select 'Add Files to ShiroGuessr...'"
echo "10. Navigate to ShiroGuessr/Resources/"
echo "11. Select both Base.lproj and ja.lproj folders"
echo "12. Ensure 'Create groups' is selected and 'ShiroGuessr' target is checked"
echo "13. Click 'Add'"
echo ""
echo "METHOD 2: Verify Files in Build Phase"
echo "--------------------------------------"
echo "1. In Xcode, select the 'ShiroGuessr' target"
echo "2. Go to the 'Build Phases' tab"
echo "3. Expand 'Copy Bundle Resources'"
echo "4. Ensure 'Localizable.strings' appears in the list"
echo "5. If not, click '+' and add the variant group"
echo ""
echo "VERIFICATION:"
echo "-------------"
echo "After adding the files, build the project to verify:"
echo "  xcodebuild -project ShiroGuessr.xcodeproj -scheme ShiroGuessr -destination 'platform=iOS Simulator,name=iPhone 17' build"
echo ""
echo "The build output should show:"
echo "  CopyStringsFile .../Base.lproj/Localizable.strings"
echo "  CopyStringsFile .../ja.lproj/Localizable.strings"
echo ""
echo "For detailed instructions, see LOCALIZATION.md"
echo "=================================================="
echo ""

# Check if files exist
if [ -f "ShiroGuessr/Resources/Base.lproj/Localizable.strings" ] && [ -f "ShiroGuessr/Resources/ja.lproj/Localizable.strings" ]; then
    echo "✓ Localization files found in correct location"
else
    echo "✗ Localization files not found! Please ensure they exist at:"
    echo "  - ShiroGuessr/Resources/Base.lproj/Localizable.strings"
    echo "  - ShiroGuessr/Resources/ja.lproj/Localizable.strings"
    exit 1
fi

# Check if LocalizationService exists
if [ -f "ShiroGuessr/Services/LocalizationService.swift" ]; then
    echo "✓ LocalizationService.swift found"
else
    echo "✗ LocalizationService.swift not found!"
    exit 1
fi

# Check if Info.plist has CFBundleLocalizations
if grep -q "CFBundleLocalizations" "ShiroGuessr/Info.plist"; then
    echo "✓ Info.plist configured with CFBundleLocalizations"
else
    echo "⚠ Warning: CFBundleLocalizations not found in Info.plist"
    echo "  Please add it manually or run this project's setup"
fi

echo ""
echo "All prerequisite files are in place!"
echo "Please follow the steps above to add the files to Xcode project."
echo ""
