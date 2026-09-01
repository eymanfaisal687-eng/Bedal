# Update Auth Screen Backgrounds

Replace the current SVG backgrounds in Step 1, Step 2, and Step 4 of the registration flow with the `splash_screen.png` image at a low opacity.

## Proposed Changes

### Auth Screens

#### [MODIFY] [signup_account_screen.dart](file:///Users/extra/bedal/lib/screens/auth/step_1/signup_account_screen.dart) (Step 1)
- Replace `SvgPicture.asset('assets/images/auth_background/background.svg', ...)` with `Image.asset('assets/images/onboarding/splash_screen.png', ...)`
- Set opacity to `0.15`.

#### [MODIFY] [security_check_screen.dart](file:///Users/extra/bedal/lib/screens/auth/step_2/security_check_screen.dart) (Step 2)
- Replace `SvgPicture.asset('assets/images/auth_background/background.svg', ...)` with `Image.asset('assets/images/onboarding/splash_screen.png', ...)`
- Set opacity to `0.15`.

#### [MODIFY] [identity_under_review_screen.dart](file:///Users/extra/bedal/lib/screens/auth/wait_for_review/identity_under_review_screen.dart) (Step 4)
- Replace `SvgPicture.asset('assets/images/auth_background/identity_background.svg', ...)` with `Image.asset('assets/images/onboarding/splash_screen.png', ...)`
- Set opacity to `0.15`.

## Verification Plan

### Manual Verification
- Navigate through the registration flow (Step 1 -> Step 2 -> Step 3 -> Step 4).
- Confirm that Step 1, Step 2, and Step 4 show the splash screen image faintly in the background.
- Confirm that Step 3 remains unchanged (or as intended).
