import 'package:latlong2/latlong.dart';
import 'hub_models.dart';

class HubData {
  static final List<Venue> mockVenues = [
    Venue(
      id: 'v1',
      name: 'Draft Cafe',
      image: 'https://picsum.photos/seed/draft/400/300',
      location: LatLng(21.5584, 39.1681),
      neighborhood: 'Al Rawdah',
      hasFreeWifi: true,
      canReserveSeat: true,
      isVerifiedHub: true,
    ),
    Venue(
      id: 'v2',
      name: 'Medd Cafe',
      image: 'https://picsum.photos/seed/medd/400/300',
      location: LatLng(21.5422, 39.1694),
      neighborhood: 'Al Rehab',
      hasFreeWifi: true,
      canReserveSeat: true,
      isVerifiedHub: true,
    ),
    Venue(
      id: 'v3',
      name: 'Brew92',
      image: 'https://picsum.photos/seed/brew92/400/300',
      location: LatLng(21.5350, 39.1850),
      neighborhood: 'Al Rehab',
      hasFreeWifi: true,
      canReserveSeat: true,
      isVerifiedHub: true,
    ),
    Venue(
      id: 'v4',
      name: '1/2 M',
      image: 'https://picsum.photos/seed/halfm/400/300',
      location: LatLng(21.5700, 39.1550),
      neighborhood: 'Al Shati',
      hasFreeWifi: true,
      canReserveSeat: true,
      isVerifiedHub: true,
    ),
  ];

  static final List<ActiveUser> mockActiveUsers = [
    ActiveUser(
      id: 'u1',
      name: 'Areej',
      avatar: 'https://picsum.photos/seed/areej/100/100',
      location: LatLng(21.5450, 39.1750),
    ),
    ActiveUser(
      id: 'u2',
      name: 'Zaid',
      avatar: 'https://picsum.photos/seed/zaid/100/100',
      location: LatLng(21.5500, 39.1800),
    ),
    ActiveUser(
      id: 'u3',
      name: 'Lina',
      avatar: 'https://picsum.photos/seed/lina/100/100',
      location: LatLng(21.5380, 39.1650),
    ),
  ];

  static final List<HobbyGuild> mockHobbyGuilds = [
    HobbyGuild(
      id: 'g1',
      userName: 'Areej',
      userAvatar: 'https://picsum.photos/seed/areej/100/100',
      userAge: 22,
      communityType: 'Expat',
      locationName: 'Brew92',
      neighborhood: 'Al Rehab',
      timeAgo: '15m ago',
      title: 'I want coffee partner ☕',
      description: 'Anyone near Brew92 join me!',
      participantCount: 4,
      participantAvatars: [
        'https://picsum.photos/seed/p1/50/50',
        'https://picsum.photos/seed/p2/50/50',
        'https://picsum.photos/seed/p3/50/50',
      ],
    ),
    HobbyGuild(
      id: 'g2',
      userName: 'Zaid',
      userAvatar: 'https://picsum.photos/seed/zaid/100/100',
      userAge: 24,
      communityType: 'Saudi',
      locationName: 'Westfield Mall',
      neighborhood: 'Al Zahra',
      timeAgo: '28m ago',
      title: 'I need shopping partner 🛍️',
      description: 'In Westfield Mall, let\'s go!',
      participantCount: 3,
      participantAvatars: [
        'https://picsum.photos/seed/p4/50/50',
        'https://picsum.photos/seed/p5/50/50',
      ],
    ),
    HobbyGuild(
      id: 'g3',
      userName: 'Lina',
      userAvatar: 'https://picsum.photos/seed/lina/100/100',
      userAge: 23,
      communityType: 'Tourist',
      locationName: 'Corniche',
      neighborhood: 'Al Shati',
      timeAgo: '1h ago',
      title: 'Looking for photography buddy 📷',
      description: 'Let\'s capture Jeddah together!',
      participantCount: 2,
      participantAvatars: [
        'https://picsum.photos/seed/p6/50/50',
      ],
    ),
  ];
}
