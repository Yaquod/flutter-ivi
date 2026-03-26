import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class MapState extends ChangeNotifier {
  LatLng _center = const LatLng(30.0444, 31.2357);
  double _zoom = 15.0;

  LatLng get center => _center;
  double get zoom => _zoom;

  void moveMap(LatLng newCenter, double newZoom, {required bool isExternal}) {
    final bool centerChanged = _center != newCenter;
    final bool zoomChanged = (_zoom - newZoom).abs() > 1e-6;

    if (!centerChanged && !zoomChanged) {
      return;
    }

    _center = newCenter;
    _zoom = newZoom;
    notifyListeners();
  }

  void setZoom(double newZoom) {
    moveMap(_center, newZoom, isExternal: true);
  }

  void setCenter(LatLng newCenter) {
    moveMap(newCenter, _zoom, isExternal: true);
  }
}

class MapManager {
  static final MapState mapState = MapState();
  static bool isMapReady = false;
}