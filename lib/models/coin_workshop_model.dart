// =========================================================================
// FILE: coin_workshop_model.dart
// ROLE: Data Model for Partner-Sponsored Workshops Redeemable with Bedal Coins
// =========================================================================

/// Data model representing a workshop sponsored by partner venues redeemable via Bedal Coins.
class CoinWorkshopModel {
  final String id; // Unique workshop ID
  final String title; // Workshop title
  final String venueName; // Partner venue name
  final String location; // Physical address / location
  final String schedule; // Formatted schedule time
  int remainingSeats; // Available seats remaining
  final int totalSeats; // Maximum total capacity
  final double coinCost; // Cost in Bedal Coins
  final String description; // Detailed workshop description
  final String materials; // Required materials or instructions
  final String imageAsset; // Visual asset image path

  CoinWorkshopModel({
    required this.id,
    required this.title,
    required this.venueName,
    required this.location,
    required this.schedule,
    required this.remainingSeats,
    required this.totalSeats,
    required this.coinCost,
    required this.description,
    required this.materials,
    required this.imageAsset,
  });

  /// Indicates if all available seats have been claimed.
  bool get isFullyBooked => remainingSeats <= 0;

  /// Returns sample partner workshops for display and testing.
  static List<CoinWorkshopModel> getSampleWorkshops() {
    return [
      CoinWorkshopModel(
        id: 'coin_ws_1',
        title: 'Pottery Masterclass Experience',
        venueName: 'Al-Balad Heritage Pottery Studio',
        location: 'Historic Al-Balad, Jeddah',
        schedule: 'Saturday • 4:00 PM',
        remainingSeats: 3,
        totalSeats: 8,
        coinCost: 1.5,
        description:
            'Experience hands-on pottery creation sponsored by Al-Balad artisans. Complimentary clay and kiln firing included for Bedal community members.',
        materials: 'Wear comfortable clothing that can get dusty. All tools provided.',
        imageAsset: 'assets/images/character_images/reem.png',
      ),
      CoinWorkshopModel(
        id: 'coin_ws_2',
        title: 'Acoustic Guitar Jam & Basics',
        venueName: 'Red Sea Music Lounge',
        location: 'Corniche Waterfront, Jeddah',
        schedule: 'Sunday • 7:00 PM',
        remainingSeats: 2,
        totalSeats: 6,
        coinCost: 2.0,
        description:
            'Partner venue sponsored acoustic guitar session. Learn chords, rhythm, and jam with fellow music learners in a relaxed seaside lounge.',
        materials: 'Acoustic guitars will be available, but bringing your own is welcome.',
        imageAsset: 'assets/images/character_images/omar.png',
      ),
      CoinWorkshopModel(
        id: 'coin_ws_3',
        title: 'Beginner Film Photography',
        venueName: 'Jeddah Lens & Light Hub',
        location: 'Tahlia Street, Jeddah',
        schedule: 'Tuesday • 5:30 PM',
        remainingSeats: 4,
        totalSeats: 10,
        coinCost: 1.0,
        description:
            'Master manual exposure, framing, and street photography techniques with professional gear provided by our gallery partner.',
        materials: 'Bring your smartphone or mirrorless camera.',
        imageAsset: 'assets/images/character_images/sara.png',
      ),
    ];
  }
}
