# Localization Guide

This document describes the localization implementation for ShiroGuessr iOS app.

## Overview

ShiroGuessr supports the following languages:
- English (Base)
- Japanese (日本語)

## Implementation

### 1. Localization Files

Localization strings are stored in `Localizable.strings` files:

- **Base (English)**: `ShiroGuessr/Resources/Base.lproj/Localizable.strings`
- **Japanese**: `ShiroGuessr/Resources/ja.lproj/Localizable.strings`

### 2. LocalizationService

A type-safe localization service is provided in `ShiroGuessr/Services/LocalizationService.swift`.

#### Usage Example

```swift
// Home screen
Text(L10n.Home.tagline)           // "Find the exact shade of white"
Text(L10n.Home.classicMode)       // "Classic Mode"

// Game screen
Text(L10n.Game.startGame)         // "Start Game"
Text(L10n.Game.findThisColor)     // "Find this color"

// Round result with parameter
Text(L10n.RoundResult.title(3))   // "Round 3 Result"
```

### 3. Adding Localization Files to Xcode Project

⚠️ **Important**: The localization files must be added to the Xcode project manually.

#### Steps to Add Localization Files:

1. Open `ShiroGuessr.xcodeproj` in Xcode
2. In the Project Navigator, right-click on the `ShiroGuessr` group
3. Select "Add Files to 'ShiroGuessr'..."
4. Navigate to `ShiroGuessr/Resources/`
5. Select both `Base.lproj` and `ja.lproj` folders
6. Ensure the following options are selected:
   - ✅ "Copy items if needed" (uncheck this if files are already in the project)
   - ✅ "Create groups"
   - ✅ Add to target: ShiroGuessr
7. Click "Add"

Alternatively, you can add the variant group:

1. In Xcode, select the `ShiroGuessr` group in Project Navigator
2. Go to File > New > File
3. Select "Strings File"
4. Name it `Localizable.strings`
5. Click "Create"
6. Select the newly created file in Project Navigator
7. Open the File Inspector (⌥⌘1)
8. Under "Localization", click "Localize..."
9. Select "Base" and click "Localize"
10. Check both "Base" and "Japanese" in the Localization section
11. Replace the generated files with the files from `ShiroGuessr/Resources/Base.lproj/` and `ShiroGuessr/Resources/ja.lproj/`

### 4. Info.plist Configuration

The `Info.plist` has been updated with the following keys:

```xml
<key>CFBundleDevelopmentRegion</key>
<string>en</string>
<key>CFBundleLocalizations</key>
<array>
    <string>en</string>
    <string>ja</string>
</array>
```

### 5. Testing Localization

#### Testing in Simulator

1. **Change Simulator Language**:
   - Open Settings app in the simulator
   - Go to General > Language & Region
   - Tap "iPhone Language"
   - Select "日本語" (Japanese)
   - Tap "Change to Japanese"
   - Restart the app

2. **Using Xcode Scheme**:
   - Edit the scheme (Product > Scheme > Edit Scheme...)
   - Go to "Run" > "Options"
   - Set "App Language" to "Japanese"
   - Run the app

#### Testing on Device

1. Open Settings on your device
2. Go to General > Language & Region
3. Add Japanese to preferred languages
4. Reorder languages to test different defaults

### 6. Localization String Categories

#### Home Screen
- `home.tagline` - Main tagline
- `home.classicMode` - Classic mode button
- `home.mapMode` - Map mode button

#### Game Screen
- `game.startGame` - Start game button
- `game.findThisColor` - Find color label (without colon)
- `game.findThisColorColon` - Find color label (with colon)
- `game.loading` - Loading text

#### Game Controls
- `controls.submitAnswer` - Submit answer button
- `controls.nextRound` - Next round button

#### Round Result Dialog
- `roundResult.title` - Round result title (with round number parameter)
- `roundResult.target` - Target label
- `roundResult.yourGuess` - Your guess label
- `roundResult.distance` - Distance label
- `roundResult.score` - Score label
- `roundResult.continue` - Continue button

#### Result Screen
- `result.gameComplete` - Game complete title
- `result.totalScore` - Total score label
- `result.outOf5000` - Out of 5000 text
- `result.roundResults` - Round results section title
- `result.playAgain` - Play again button
- `result.share` - Share button
- `result.copyToClipboard` - Copy to clipboard button

#### Share Service
- `share.score` - Score label for sharing
- `share.round` - Round label for sharing (with round number parameter)
- `share.distance` - Distance label for sharing

### 7. Adding New Localized Strings

When adding new UI text:

1. Add the key-value pair to both `Base.lproj/Localizable.strings` and `ja.lproj/Localizable.strings`
2. Add a static property or function to the appropriate enum in `LocalizationService.swift`
3. Use the property in your SwiftUI view: `Text(L10n.YourCategory.yourKey)`

Example:

```swift
// In Localizable.strings (Base)
"settings.title" = "Settings";

// In Localizable.strings (ja)
"settings.title" = "設定";

// In LocalizationService.swift
enum Settings {
    static let title = NSLocalizedString("settings.title", comment: "Settings screen title")
}

// In your view
Text(L10n.Settings.title)
```

### 8. Best Practices

1. **Always use L10n constants** instead of hardcoded strings
2. **Provide meaningful comments** in `NSLocalizedString` calls
3. **Keep keys organized** by screen or feature
4. **Test all languages** before releasing
5. **Use parameters** for dynamic content (e.g., round numbers, scores)
6. **Consider text expansion** - Japanese text may be longer or shorter than English
7. **Avoid concatenation** - use format strings with placeholders instead

### 9. Layout Considerations

The app uses Material Design principles which handle text length variations well. However, test all screens in both languages to ensure:

- Text doesn't overflow containers
- Buttons remain readable
- Multi-line text wraps appropriately
- Tab bar items remain visible

### 10. Future Languages

To add a new language:

1. Create a new `.lproj` folder in `ShiroGuessr/Resources/` (e.g., `es.lproj` for Spanish)
2. Copy `Localizable.strings` from `Base.lproj` to the new folder
3. Translate all strings
4. Add the language code to `CFBundleLocalizations` in `Info.plist`
5. Add the localization in Xcode (File Inspector for the variant group)
6. Test thoroughly

## Troubleshooting

### Strings Not Updating

1. Clean build folder (⇧⌘K)
2. Delete derived data
3. Rebuild the project

### Strings Showing Keys Instead of Values

1. Verify the `.strings` file is properly formatted
2. Check that the file is included in the target's "Copy Bundle Resources" build phase
3. Ensure the key exists in the `.strings` file

### Wrong Language Displayed

1. Check device/simulator language settings
2. Verify `CFBundleLocalizations` in `Info.plist`
3. Check Xcode scheme language settings (for testing)

## Resources

- [Apple: Localizing Your App](https://developer.apple.com/documentation/xcode/localizing-your-app)
- [Apple: Localization](https://developer.apple.com/localization/)
- [Material Design: Internationalization](https://m3.material.io/foundations/content-design/internationalization)
