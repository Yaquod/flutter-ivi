import 'package:flutter/material.dart';
import 'package:flutter_ivi/features/map/logic/map_manager.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class BaseMab extends StatefulWidget {
  final Widget? overlayChild;

  const BaseMab({
    super.key,
    this.overlayChild,
  });

  @override
  State<BaseMab> createState() => _BaseMabState();
}

class _BaseMabState extends State<BaseMab> {
  late final MapController _localController;
  bool _isUserDragging = false;
  bool _isProgrammaticMove = false;

  @override
  void initState() {
    super.initState();
    _localController = MapController();
    MapManager.mapState.addListener(_onMapStateChanged);
  }

  void _onMapStateChanged() {
    if (_isUserDragging || _isProgrammaticMove) return;

    final LatLng targetCenter = MapManager.mapState.center;
    final double targetZoom = MapManager.mapState.zoom;

    final LatLng currentCenter = _localController.camera.center;
    final double currentZoom = _localController.camera.zoom;

    if (currentCenter == targetCenter && (currentZoom - targetZoom).abs() < 1e-6) {
      return;
    }

    _isProgrammaticMove = true;
    _localController.move(targetCenter, targetZoom);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isProgrammaticMove = false;
    });
  }

  @override
  void dispose() {
    MapManager.mapState.removeListener(_onMapStateChanged);
    _localController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        children: [
          FlutterMap(
            mapController: _localController,
            options: MapOptions(
              initialCenter: MapManager.mapState.center,
              initialZoom: MapManager.mapState.zoom,
              onMapReady: () => MapManager.isMapReady = true, 
              onPositionChanged: (position, hasGesture) {
                _isUserDragging = hasGesture;

                if (hasGesture && !_isProgrammaticMove) {
                  final LatLng center = position.center;
                  final double zoom = position.zoom;
                  MapManager.mapState.moveMap(center, zoom, isExternal: false);
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png",
                subdomains: const ['a', 'b', 'c', 'd'],
                retinaMode: RetinaMode.isHighDensity(context),
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: MapManager.mapState.center,
                    width: 60,
                    height: 60,

                    child: Icon(
                      Icons.location_on,
                      color: Colors.blue.shade400,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (widget.overlayChild != null) widget.overlayChild!,
        ],
      ),
    );
  }
}