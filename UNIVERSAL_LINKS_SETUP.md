# Universal Links Setup Guide

This document explains how to configure Universal Links for ShiroGuessr iOS app.

## Overview

Universal Links allow users to tap a link to your website and get seamlessly redirected to your installed app without going through Safari. If the app isn't installed, the link opens in Safari.

## iOS App Configuration

The iOS app is already configured with:

1. **Entitlements** (`ShiroGuessr.entitlements`):
   - Associated Domains: `applinks:shiro-guessr.pages.dev`

2. **URL Handling** (`ShiroGuessrApp.swift`):
   - `.onOpenURL` modifier to handle incoming Universal Links
   - Handles `/ios` path for share links

## Web Server Configuration (Required)

The following file needs to be deployed on the web server at:
`https://shiro-guessr.pages.dev/.well-known/apple-app-site-association`

### Apple App Site Association (AASA) File

```json
{
  "applinks": {
    "apps": [],
    "details": [
      {
        "appID": "TEAM_ID.com.kurogoma4d.ShiroGuessr",
        "paths": ["/ios", "/ios/*"]
      }
    ]
  }
}
```

**Important Notes:**

1. **Replace `TEAM_ID`** with your actual Apple Developer Team ID
   - Find it at: https://developer.apple.com/account/#/membership/
   - Format: 10 alphanumeric characters (e.g., `A1B2C3D4E5`)

2. **Bundle ID** should match your app's Bundle Identifier
   - Default: `com.kurogoma4d.ShiroGuessr`
   - Check in Xcode: Project Settings → General → Identity

3. **File Requirements:**
   - Must be served over HTTPS
   - Must be at `/.well-known/apple-app-site-association`
   - Content-Type: `application/json` (recommended)
   - No file extension
   - Must be accessible without redirects

## How It Works

1. User completes a game and shares results
2. Share text includes: `https://shiro-guessr.pages.dev/ios`
3. When another user taps the link:
   - **If app is installed**: Opens the app directly
   - **If app is not installed**: Opens Safari and shows the `/ios` page

## Web Page Implementation (`/ios` route)

Create a landing page at `https://shiro-guessr.pages.dev/ios` that:

1. Detects if the app is installed (via user-agent or smart banner)
2. Shows one of:
   - Link to App Store (when app is released)
   - Download/TestFlight invitation
   - Fallback to web version of the game

Example HTML for `/ios` page:

```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="apple-itunes-app" content="app-id=YOUR_APP_ID">
  <title>白Guessr - iOS App</title>
</head>
<body>
  <h1>白Guessr iOS App</h1>
  <p>Download the iOS app to play:</p>
  <a href="https://apps.apple.com/app/idYOUR_APP_ID">Download on App Store</a>

  <!-- Or fallback to web version -->
  <p><a href="https://shiro-guessr.pages.dev/">Play Web Version</a></p>
</body>
</html>
```

## Testing Universal Links

### Before App Store Release

1. **Local Testing:**
   - Deploy AASA file to staging server
   - Update entitlements with staging domain
   - Test with TestFlight builds

2. **Verify AASA File:**
   - Use Apple's validator: https://search.developer.apple.com/appsearch-validation-tool/
   - Check file accessibility: `curl https://shiro-guessr.pages.dev/.well-known/apple-app-site-association`

### Testing Checklist

- [ ] AASA file is accessible via HTTPS
- [ ] AASA file has correct Team ID and Bundle ID
- [ ] App has Associated Domains entitlement
- [ ] Test link opens app when installed
- [ ] Test link opens Safari when app not installed
- [ ] Smart banner shows in Safari (optional)

## Troubleshooting

### Universal Links not working

1. **Check AASA file is accessible:**
   ```bash
   curl -I https://shiro-guessr.pages.dev/.well-known/apple-app-site-association
   ```

2. **Verify AASA content:**
   ```bash
   curl https://shiro-guessr.pages.dev/.well-known/apple-app-site-association | json_pp
   ```

3. **Clear iOS cache:**
   - Uninstall and reinstall the app
   - Or wait 24 hours for iOS to refresh AASA cache

4. **Check entitlements:**
   - Verify in Xcode: Target → Signing & Capabilities → Associated Domains

5. **Test with different scenarios:**
   - Tap link in Notes app
   - Tap link in Messages
   - Long press link and choose "Open in App"

### Link opens Safari instead of app

- iOS opens Universal Links in Safari if:
  - User has previously chosen "Open in Safari" for this domain
  - AASA file is not properly configured
  - App is not installed

- **Fix:** Long press the link and choose "Open in [App Name]"

## References

- [Apple Developer: Supporting Universal Links](https://developer.apple.com/documentation/xcode/supporting-universal-links-in-your-app)
- [Apple Developer: AASA File Reference](https://developer.apple.com/documentation/bundleresources/applinks)
- [AASA Validator](https://search.developer.apple.com/appsearch-validation-tool/)
