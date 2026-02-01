# ShiroGuessr

This project is an iOS version of `白Guessr`.

## GitHub Repository

This repository is hosted in `Kurogoma4D/ShiroGuessr-iOS`.
Use the `gh` command to perform repository operations.

## UI Design

UI design implementation should be based on the principles of material-thinking.

## Testing

This project uses **Swift Testing** framework (not XCTest) for all tests.

### Running Tests from CLI

This is an Xcode project (not SPM), so use `xcodebuild` instead of `swift test`:

```bash
# Run all tests (requires scheme to be created in Xcode first)
xcodebuild test -project ShiroGuessr.xcodeproj -scheme ShiroGuessr -destination 'platform=iOS Simulator,name=iPhone 16'

# Run specific test target
xcodebuild test -project ShiroGuessr.xcodeproj -scheme ShiroGuessr -destination 'platform=iOS Simulator,name=iPhone 16' -only-testing:ShiroGuessrTests

# Run specific test suite
xcodebuild test -project ShiroGuessr.xcodeproj -scheme ShiroGuessr -destination 'platform=iOS Simulator,name=iPhone 16' -only-testing:ShiroGuessrTests/ColorServiceTests
```

**Note**: This project currently has no schemes. Create one in Xcode (Product > Scheme > Manage Schemes) before running CLI tests.
