import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:filament_scene/filament_scene.dart';
import 'package:filament_scene/camera/camera.dart';
import 'package:filament_scene/generated/messages.g.dart' show FilamentViewApi;
import 'package:filament_scene/math/vectors.dart';

import '../providers/autoware_state.dart';

/// 3D environment viewport powered by filament_scene.
class RobotaxiEnvironment extends StatefulWidget {
  const RobotaxiEnvironment({super.key});

  @override
  State<RobotaxiEnvironment> createState() => _RobotaxiEnvironmentState();
}

class _RobotaxiEnvironmentState extends State<RobotaxiEnvironment> {
  final FilamentViewApi _filament = FilamentViewApi();
  late final SceneView _sceneView;

  @override
  void initState() {
    super.initState();
    _sceneView = _buildSceneView();
  }

  SceneView _buildSceneView() {
    return SceneView(
      filament: _filament,
      scene: Scene(
        skybox: ColorSkybox(color: const Color(0xFF1a1a2e)),
        lights: [
          Light(
            id: generateGuid(),
            type: LightType.directional,
            colorTemperature: 6500,
            intensity: 100000,
            direction: Vector3(0, -1, -0.3),
            castShadows: true,
          ),
          Light(
            id: generateGuid(),
            type: LightType.point,
            color: Colors.white,
            intensity: 4,
            castShadows: true,
            castLight: true,
            falloffRadius: 10,
            position: Vector3(0, 8, 0),
            direction: Vector3(0, -1, 0),
          ),
        ],
      ),
      cameras: [
        Camera(
          id: generateGuid(),
          orbitOriginPoint: Vector3(0, 1.5, 0),
          orbitDistance: 8.0,
          orbitAngles: Vector2(0.0, math.pi / -8),
          targetPoint: Vector3(0, 0, 0),
        ),
      ],
      models: [
        GlbModel.asset(
          id: generateGuid(),
          assetPath: 'assets/models/robotaxi/free_porsche_911_carrera_4s.glb',
          position: Vector3(0, 0, 0),
          scale: Vector3.all(1),
          rotation: Quaternion.identity(),
          receiveShadows: true,
          castShadows: true,
          name: 'ego_vehicle',
        ),
        GlbModel.asset(
          id: generateGuid(),
          assetPath: 'assets/models/robotaxi/american_road.glb',
          position: Vector3(0, -0.5, 0),
          scale: Vector3(2, 1, 2),
          rotation: Quaternion.identity(),
          receiveShadows: true,
          castShadows: false,
          name: 'ground',
        ),
      ],
      onCreated: (SceneController controller) {
        debugPrint('Robotaxi scene created (id=${controller.id})');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _sceneView,
        const EnvironmentHud(),
      ],
    );
  }
}

/// 2D HUD overlay on top of the filament_scene viewport.
class EnvironmentHud extends StatelessWidget {
  const EnvironmentHud({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AutowareState>();
    final adas = state.cluster?.adas;

    return Stack(
      children: [
        Positioned(
          left: 24,
          bottom: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.speedMph.toStringAsFixed(0),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.w200,
                  fontFamily: 'monospace',
                  height: 0.9,
                ),
              ),
              Text(
                'MPH  ·  ${state.gearLabel}',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        if (adas != null)
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${adas.obstacleCount} obs  ·  ${adas.vehicleCount} veh  ·  ${adas.pedestrianCount} ped',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ),
      ],
    );
  }
}
