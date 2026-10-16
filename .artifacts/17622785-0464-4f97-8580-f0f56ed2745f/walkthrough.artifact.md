# Walkthrough - Redeem with Bedal Coins Feature

I have successfully added the new **"Redeem with Bedal Coins"** feature to the Explore screen, allowing users to exchange earned Bedal Coins for complimentary partner-sponsored workshop seats.

## Changes Made

### 1. Data Model & State Management
- **[NEW] [coin_workshop_model.dart](file:///Users/extra/bedal/lib/models/coin_workshop_model.dart)**: Created the `CoinWorkshopModel` representing partner-sponsored workshops with coin redemption costs, remaining seats, venue details, and descriptions.
- **[MODIFY] [signup_provider.dart](file:///Users/extra/bedal/lib/providers/signup_provider.dart)**: Added Bedal Coin balance tracking (`bedalCoins`), redeemed workshop tracking (`redeemedWorkshops`), and robust `redeemWorkshop()` transaction logic with balance and capacity checks.

### 2. UI Components & Interaction Flow
- **[NEW] [redeem_workshops_section.dart](file:///Users/extra/bedal/lib/screens/explore/widgets/workshops/redeem_workshops_section.dart)**: Added the new section header ("Redeem with Bedal Coins", subtitle: "Your skills earn you new experiences."), coin icon, "View all" action, and horizontally scrollable workshop cards.
- **[NEW] [coin_workshop_card.dart](file:///Users/extra/bedal/lib/screens/explore/widgets/workshops/coin_workshop_card.dart)**: Polished dark-themed card displaying workshop title, partner venue, schedule, coin cost tag, and remaining seat availability.
- **[NEW] [coin_workshop_detail_sheet.dart](file:///Users/extra/bedal/lib/screens/explore/widgets/workshops/coin_workshop_detail_sheet.dart)**: Interactive bottom sheet showing full workshop details, current user coin balance comparison, requirements, and a "Redeem & Book" action with sufficient-coin validation and success/error feedback.
- **[MODIFY] [explore_screen.dart](file:///Users/extra/bedal/lib/screens/explore/explore_screen.dart)**: Integrated `RedeemWorkshopsSection` naturally beneath the existing `GroupWorkshopsSection`.

## Verification Results
- **Flutter Analysis**: Ran `flutter analyze` across all modified and new files with **0 issues found**.
- **Business Rules Enforced**:
  - Validates user has sufficient Bedal Coins before confirming redemption.
  - Prevents negative balances and duplicate bookings.
  - Decrements seat count in real-time.
  - Fully compatible with existing Bedal architecture and design system.
