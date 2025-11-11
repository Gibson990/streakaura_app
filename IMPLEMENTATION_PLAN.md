# Implementation Plan: Login Screen, App Review, and Critical Alarm Notifications

## Overview
This plan implements:
1. Login screen with Google and Apple Sign-In (optional, after splash)
2. App review prompt after first check-in
3. Critical alarm notifications that bypass DND with action buttons

## 1. Add Dependencies
**File: `pubspec.yaml`**
- Add `in_app_review: ^2.0.9` for app review prompts
- Add `google_sign_in: ^6.2.1` for Google authentication
- Add `sign_in_with_apple: ^5.0.0` for Apple Sign-In

## 2. Create Login Screen
**New File: `lib/presentation/screens/login_screen.dart`**
- Logo at top (use app logo from assets)
- Decorated text in center: "Start Your Daily Glow" with tagline
- White buttons below with icons:
  - Google Sign-In button (white background, Google icon, text "Continue with Google")
  - Apple Sign-In button (white background, Apple icon, text "Continue with Apple") - iOS only
  - Optional "Skip" text button at bottom
- After login/skip: Navigate to onboarding (if not completed) or home screen
- Store login state in Hive settings box

## 3. Update App Navigation Flow
**File: `lib/app.dart`**
- Modify `_getInitialScreen()`:
  1. Check if user is logged in (from Hive settings)
  2. If logged in → check onboarding → show Home or Onboarding
  3. If not logged in → show LoginScreen
- New flow: Splash → Login → Onboarding → Home

## 4. Create Authentication Service
**New File: `lib/services/auth_service.dart`**
- Methods:
  - `signInWithGoogle()` - Handle Google Sign-In flow
  - `signInWithApple()` - Handle Apple Sign-In flow (iOS only)
  - `signOut()` - Sign out and clear auth state
  - `isLoggedIn()` - Check if user is logged in
  - `getCurrentUser()` - Get current user info (name, email, provider)
- Store auth state in Hive settings box (`user_logged_in`, `user_provider`, `user_email`, `user_name`)
- Handle errors gracefully with try-catch

## 5. Add App Review Service
**New File: `lib/services/app_review_service.dart`**
- Use `in_app_review` package
- Method: `requestReview()` - Request app review if available
- Track review request in Hive settings box (`review_requested`)
- Only request once per user
- Trigger: After first habit check-in (detect in home_screen.dart)

## 6. Update Habit Model
**File: `lib/data/models/habit_model.dart`**
- Add field: `isCriticalAlarm` (bool, default false)
- Add as `@HiveField(11) bool isCriticalAlarm;`
- Update constructor to include `this.isCriticalAlarm = false`
- Regenerate Hive adapter after changes

## 7. Update Notification Service
**File: `lib/services/notification_service.dart`**
- Add method: `scheduleCriticalAlarm()` for critical alarms
- Update `scheduleHabitReminder()` to accept `isCriticalAlarm` parameter
- For critical alarms:
  - Android: `importance: Importance.max`, `priority: Priority.max`, `fullScreenIntent: true`, separate channel "critical_alarms"
  - iOS: `interruptionLevel: InterruptionLevel.critical` (iOS 15+), `presentAlert: true`, `presentSound: true`
- Add action buttons:
  - "Open App" action (opens app)
  - "Stop" action (marks habit as checked in)
- Handle notification actions in `initialize()` with `onDidReceiveNotificationResponse` callback
- Use payload to pass habit ID for action handling

## 8. Update Add/Edit Habit Screen
**File: `lib/presentation/screens/add_edit_habit_screen.dart`**
- Add toggle switch: "Critical Alarm" (only visible when reminder time is set)
- Position: Below reminder time picker
- Save `isCriticalAlarm` value when creating/editing habit
- When scheduling notification, pass `isCriticalAlarm` flag to notification service

## 9. Add Alarm Settings
**File: `lib/presentation/screens/settings_screen.dart`**
- Add new section: "Alarm Settings"
- Toggle: "Enable Critical Alarms" (master switch, stored in Hive)
- Info text: "Critical alarms bypass Do Not Disturb mode"
- Button: "Open System Settings" (links to iOS/Android notification settings)
- Show current alarm permission status

## 10. Handle Notification Actions
**File: `lib/main.dart`**
- Initialize notification service with action handlers
- Handle "Open App" action: Navigate to home screen (use navigator key)
- Handle "Stop" action: 
  - Get habit ID from notification payload
  - Use habit service to mark habit as checked in
  - Dismiss notification
- Use global navigator key for navigation from background

## 11. Update Android Configuration
**File: `android/app/src/main/AndroidManifest.xml`**
- Add permission: `<uses-permission android:name="android.permission.USE_FULL_SCREEN_INTENT" />`
- Create notification channel for critical alarms in code (NotificationService)

## 12. Update iOS Configuration
**File: `ios/Runner/Info.plist`**
- Add key: `UIBackgroundModes` with `remote-notification` if needed
- Critical alerts require special entitlement (configure in Xcode)
- Add notification categories with action buttons

## Implementation Order:
1. Add dependencies to pubspec.yaml
2. Create auth service
3. Create login screen
4. Update app navigation flow
5. Create app review service
6. Update habit model
7. Update notification service for critical alarms
8. Update add/edit habit screen
9. Add alarm settings
10. Handle notification actions
11. Update platform configurations

## Testing Checklist:
- [ ] Login with Google works
- [ ] Login with Apple works (iOS)
- [ ] Skip login works
- [ ] App review prompts after first check-in
- [ ] Critical alarms bypass DND on iOS
- [ ] Critical alarms show full screen on Android
- [ ] "Open App" button works
- [ ] "Stop" button marks habit as checked in
- [ ] Alarm settings toggle works
- [ ] System settings link works

