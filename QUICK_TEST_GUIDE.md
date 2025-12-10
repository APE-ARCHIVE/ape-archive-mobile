# Quick Test Guide - Google Authentication

## Test the Complete Flow

### 1. Start the App
```bash
flutter run
```

### 2. Test Sign-In
1. Tap **"Sign in with Google"** button
2. Browser opens with Google OAuth page
3. Sign in with your Google account
4. Grant permissions when asked
5. Browser redirects and app reopens
6. User is signed in and navigated to home

### 3. Verify Success
- Check if home screen loads
- Profile screen should show your Google account info
- Token should be stored (persists on app restart)

## Test Deep Link Manually

### Android
```bash
# Test deep link with fake token
adb shell am start -W -a android.intent.action.VIEW \
  -d "apearchive://auth?access_token=fake_token_for_testing" \
  lk.apearchive.app

# Check logs
adb logcat | grep -i "deep link"
```

### iOS
```bash
# Test deep link with fake token
xcrun simctl openurl booted \
  "apearchive://auth?access_token=fake_token_for_testing"

# Check logs
flutter logs | grep -i "deep link"
```

## Expected Debug Logs

When deep link is received:
```
Deep link received: apearchive://auth?access_token=...
Handling deep link: apearchive://auth?access_token=...
Access token received from deep link
```

## Common Issues

### Browser doesn't open
- Check internet connection
- Verify backend URL is accessible
- Check `launchUrl` permissions

### App doesn't reopen after auth
- Verify AndroidManifest.xml intent filter
- Verify Info.plist URL types
- Test deep link manually

### Token not stored
- Check SecureStorage initialization
- Verify token format from backend
- Check app permissions

## Success Indicators

✅ Browser opens to Google sign-in  
✅ After sign-in, app reopens automatically  
✅ Home screen loads with user data  
✅ Profile shows correct user info  
✅ Token persists after app restart  

## Backend Requirements

Your backend MUST redirect to:
```
apearchive://auth?access_token=<JWT_TOKEN>
```

After successful Google OAuth callback.
