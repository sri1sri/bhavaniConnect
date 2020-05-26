import 'dart:async';

import 'package:bhavaniconnect/models/area.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';

class CurrentArea {
  static final CurrentArea instance = CurrentArea();
  Area _latest;
  StreamController<Area> _controller;
  final Location location = new Location();

  CurrentArea() {
    _controller = StreamController<Area>.broadcast(onListen: () async {
      // playback the latest area to new listener
      if (_latest != null) {
        _controller.sink.add(_latest);
      } else {
        // or if the map hasn't been accessed yet try getting the current location
        try {
          var currentLocation = await getCurrentLocation();
          _latest = Area(currentLocation);
          _controller.sink.add(_latest);
        } catch (err) {}
      }
    });
  }

  Future<LatLng> getCurrentLocation() async {
    var currentLocation = await location.getLocation();
    return LatLng(currentLocation.latitude, currentLocation.longitude);
  }

  void updated(Area area) {
    _latest = area;
    _controller.sink.add(area);
  }

  Stream<Area> get stream => _controller.stream;

  dispose() {
    _controller.close();
  }
}
