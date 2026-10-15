import 'package:latlong2/latlong.dart';

class Venue {
  final String id;
  final String name;
  final String image;
  final LatLng location;
  final String neighborhood;
  final bool hasFreeWifi;
  final bool canReserveSeat;
  final bool isVerifiedHub;
  final String description;

  Venue({
    required this.id,
    required this.name,
    required this.image,
    required this.location,
    required this.neighborhood,
    this.hasFreeWifi = false,
    this.canReserveSeat = false,
    this.isVerifiedHub = false,
    this.description = '',
  });
}

class ActiveUser {
  final String id;
  final String name;
  final String avatar;
  final LatLng location;
  final bool isOnline;
  final String? currentVenueId;

  ActiveUser({
    required this.id,
    required this.name,
    required this.avatar,
    required this.location,
    this.isOnline = true,
    this.currentVenueId,
  });
}

class HobbyGuild {
  final String id;
  final String userName;
  final String userAvatar;
  final int? userAge;
  final String? communityType; // Saudi, Expat, Tourist
  final String locationName;
  final String neighborhood;
  final String timeAgo;
  final bool isUserOnline;
  final String title;
  final String description;
  final int participantCount;
  final List<String> participantAvatars;

  HobbyGuild({
    required this.id,
    required this.userName,
    required this.userAvatar,
    this.userAge,
    this.communityType,
    required this.locationName,
    required this.neighborhood,
    required this.timeAgo,
    this.isUserOnline = true,
    required this.title,
    required this.description,
    required this.participantCount,
    this.participantAvatars = const [],
  });
}
