import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'hub_models.dart';

class HubState extends ChangeNotifier {
  Venue? _selectedVenue;
  Venue? get selectedVenue => _selectedVenue;

  final MapController mapController = MapController();

  void selectVenue(Venue? venue, {bool moveMap = true}) {
    if (_selectedVenue?.id == venue?.id) return;
    _selectedVenue = venue;
    notifyListeners();

    if (venue != null && moveMap) {
      mapController.move(venue.location, 15.5);
    }
  }
}
