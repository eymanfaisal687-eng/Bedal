# Walkthrough - App Header & Bottom Navigator Fix

I have fixed the visibility issues for the `AppHeader` and `BottomNavBar` and ensured the `HomeScreen` content is correctly positioned between them.

## Changes Made

### Navigation Logic
- Updated `lib/screens/auth/login_screen.dart` and `lib/screens/auth/identity_under_review_screen.dart` to navigate to `MainLayout` instead of directly to `HomeScreen`. This ensures the shell components (header and nav bar) are initialized.

### Main Layout Refactoring
- Refactored `lib/screens/widgets/main_layout.dart` to use a `Column` instead of a `Stack`.
- Positioned the `AppHeader` at the top of the column and wrapped the `IndexedStack` in an `Expanded` widget. This forces the screen content to take up the space between the header and the bottom navigation bar.

### Screen Cleanup
- Removed redundant `Scaffold` and `SafeArea` widgets from `HomeScreen`, `ExploreScreen`, and `HubsScreen` to allow them to sit cleanly within the `MainLayout` container.
- Removed hardcoded `SizedBox` cushions that were previously used to manually offset content from the overlapping header and bottom bar.

## Verification Suggestions

### Manual Verification
1. **Login Flow**: Complete the login process and confirm the header and bottom navigator appear immediately.
2. **Home Tab**: Verify `home_sample` video content starts below the app header and ends at the bottom navigator.
3. **Tab Switching**: Navigate through all tabs (Explore, Hubs, etc.) and ensure the layout remains consistent across all views.
