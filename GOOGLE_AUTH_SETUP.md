# Google Authentication Flow - Implementation Guide

## Overview
The Google authentication flow has been fully implemented using OAuth 2.0 with deep link callbacks.

## Implementation Components

### 1. Deep Link Service (`lib/core/services/deep_link_service.dart`)
- Handles incoming deep links from the OAuth callback
- Listens for `apearchive://auth` deep links
- Extracts access tokens from callback URLs

### 2. Updated Main App (`lib/main.dart`)
- Initializes deep link handling on app startup
- Processes OAuth callbacks automatically
- Integrates with auth provider for token handling

### 3. Auth Repository Updates
- `initiateGoogleSignIn()`: Returns backend OAuth URL
- `handleAuthCallback()`: Processes access token and fetches user data
- Token storage and user caching

### 4. Platform Configuration

#### Android (`android/app/src/main/AndroidManifest.xml`)
```xml
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data
        android:scheme="apearchive"
        android:host="auth" />
</intent-filter>
```

#### iOS (`ios/Runner/Info.plist`)
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>apearchive</string>
        </array>
        <key>CFBundleURLName</key>
        <string>lk.apearchive.app</string>
    </dict>
</array>
```

## Authentication Flow

### User Journey
1. **User taps "Sign in with Google"**
   - App shows "Opening Google Sign-In..." message
   - Opens backend URL: `https://server.apearchive.lk/api/v1/auth/google`

2. **Backend Redirects to Google**
   - Backend handles Google OAuth initialization
   - User sees Google sign-in page in browser

3. **User Authorizes App**
   - User selects Google account and grants permissions
   - Google redirects back to backend with auth code

4. **Backend Processes Auth**
   - Backend exchanges auth code for tokens
   - Backend creates/updates user in database
   - Backend redirects to: `apearchive://auth?access_token=<token>`

5. **App Receives Deep Link**
   - Deep link service catches the callback
   - Extracts access token from URL parameters
   - Calls `authProvider.handleAuthCallback(accessToken)`

6. **App Completes Sign-In**
   - Repository stores token securely
   - Fetches user profile from backend
   - Caches user data locally
   - Navigates to home screen

## Backend Requirements

Your backend must:

1. **Provide OAuth Initialization Endpoint**
   ```
   GET /api/v1/auth/google
   ```
   - Redirects to Google OAuth consent screen
   - Includes redirect_uri for Google callback

2. **Handle Google Callback**
   ```
   GET /api/v1/auth/google/callback?code=<auth_code>
   ```
   - Exchanges auth code for Google access token
   - Creates/updates user in database
   - Generates JWT access token
   - Redirects to: `apearchive://auth?access_token=<jwt_token>`

3. **Provide User Profile Endpoint**
   ```
   GET /api/v1/auth/me
   Headers: Authorization: Bearer <access_token>
   ```
   - Returns authenticated user information

## Testing Instructions

### Test on Android Emulator/Device

1. **Build and install the app**
   ```bash
   flutter run
   ```

2. **Test the flow**
   - Tap "Sign in with Google"
   - Browser should open with Google sign-in
   - Sign in with your Google account
   - App should automatically open and complete sign-in

3. **Debug deep links** (if needed)
   ```bash
   adb shell am start -W -a android.intent.action.VIEW -d "apearchive://auth?access_token=test_token" lk.apearchive.app
   ```

### Test on iOS Simulator/Device

1. **Build and install the app**
   ```bash
   flutter run
   ```

2. **Test the flow**
   - Tap "Sign in with Google"
   - Safari should open with Google sign-in
   - Sign in with your Google account
   - App should automatically open and complete sign-in

3. **Debug deep links** (if needed)
   ```bash
   xcrun simctl openurl booted "apearchive://auth?access_token=test_token"
   ```

## Troubleshooting

### Deep Link Not Opening App

**Android:**
- Check AndroidManifest.xml has the intent filter
- Verify package name matches bundle ID
- Test with `adb shell am start` command

**iOS:**
- Check Info.plist has CFBundleURLTypes
- Verify URL scheme is registered
- Test with `xcrun simctl openurl` command

### Token Not Being Stored

- Check SecureStorage permissions
- Verify token format from backend
- Check debug logs for errors

### User Profile Not Loading

- Verify `/auth/me` endpoint works with token
- Check Authorization header format: `Bearer <token>`
- Verify token is valid and not expired

## Security Considerations

1. **Deep Link Validation**
   - Always validate the deep link scheme and host
   - Verify token format before processing

2. **Token Storage**
   - Tokens stored in secure storage (encrypted)
   - Never log tokens in production

3. **HTTPS Only**
   - All API calls use HTTPS
   - Deep links redirect from HTTPS callback

## User Feedback

The implementation provides clear feedback:
- Loading states during sign-in
- Error messages for failures
- Success navigation to home screen
- "Signing in..." message during auth processing

## Next Steps

To complete the integration:

1. **Backend Setup**
   - Configure Google OAuth credentials
   - Set redirect URI: `https://server.apearchive.lk/api/v1/auth/google/callback`
   - Add deep link redirect: `apearchive://auth?access_token={token}`

2. **Test Environment**
   - Test with real Google accounts
   - Verify token expiration handling
   - Test offline/online scenarios

3. **Production**
   - Update OAuth consent screen in Google Console
   - Configure production redirect URIs
   - Monitor authentication metrics
