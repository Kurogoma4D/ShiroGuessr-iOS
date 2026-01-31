# Setup Guide for ShiroGuessr iOS Project

This guide provides instructions for completing the project setup after cloning the repository.

## Manual Xcode Configuration Steps

After pulling the latest changes, you need to manually add the new files and folders to the Xcode project:

### 1. Add New Folders to Xcode Project

1. Open `ShiroGuessr.xcodeproj` in Xcode
2. Right-click on the `ShiroGuessr` folder in the Project Navigator
3. Select "Add Files to ShiroGuessr..."
4. Navigate to the `ShiroGuessr` directory and add the following folders with "Create groups" option:
   - `Models/`
   - `Services/`
   - `Views/Screens/`
   - `Views/Components/`
   - `ViewModels/`

### 2. Remove Old Boilerplate Files

The following files are no longer needed and should be removed from the project:
1. Right-click on these files in Xcode Project Navigator and select "Delete" → "Move to Trash":
   - `ContentView.swift` (replaced by `Views/Screens/HomeScreen.swift`)
   - `Item.swift` (SwiftData boilerplate no longer needed)

### 3. Verify Build

1. Select a simulator (e.g., iPhone 17)
2. Build the project (⌘B)
3. Run the project (⌘R)
4. You should see the HomeScreen with "ShiroGuessr" title

## Project Structure After Setup

```
ShiroGuessr/
├── Models/                          # Data models (currently empty, ready for future models)
├── Services/                        # Business logic and API services (currently empty)
├── Views/
│   ├── Screens/
│   │   └── HomeScreen.swift        # Main home screen
│   └── Components/
│       └── ColorSystem.swift       # Material Design 3 color system
├── ViewModels/                     # MVVM ViewModels (currently empty)
├── Assets.xcassets/                # Asset catalog
└── ShiroGuessrApp.swift            # App entry point with NavigationStack
```

## Features Implemented

### Material Design 3 Color System
- Complete MD3 color palette defined in `ColorSystem.swift`
- Primary, Secondary, Tertiary color schemes
- Surface, Background, and Error colors
- Typography scale (Display, Headline, Title, Body, Label)

### Navigation Setup
- `NavigationStack` configured in `ShiroGuessrApp.swift`
- Ready for push/pop navigation patterns
- Type-safe routing can be added as needed

### Architecture
- MVVM structure with folder organization
- SwiftUI `@Observable` ready for state management
- Clean separation of concerns

## Next Steps

After completing these manual setup steps, the project is ready for feature development. Future phases will include:
- Game logic implementation
- Map integration
- Scoring system
- User interface screens
- API integration for location data

## Troubleshooting

### Build Errors After Adding Files

If you encounter build errors:
1. Clean build folder (⌘⇧K)
2. Clean derived data: `rm -rf ~/Library/Developer/Xcode/DerivedData`
3. Restart Xcode
4. Rebuild the project

### Missing Color/Font Definitions

If you see errors about undefined colors or fonts:
- Ensure `Views/Components/ColorSystem.swift` is added to the project
- Check that the file is included in the ShiroGuessr target

### Navigation Issues

If HomeScreen doesn't appear:
- Verify `Views/Screens/HomeScreen.swift` is added to the project
- Check `ShiroGuessrApp.swift` imports and references
