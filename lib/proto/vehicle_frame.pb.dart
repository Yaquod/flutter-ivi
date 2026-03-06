// This is a generated file - do not edit.
//
// Generated from vehicle_frame.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'vehicle_frame.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'vehicle_frame.pbenum.dart';

class VelocityData extends $pb.GeneratedMessage {
  factory VelocityData({
    $core.double? speedMps,
    $core.double? speedKmh,
  }) {
    final result = create();
    if (speedMps != null) result.speedMps = speedMps;
    if (speedKmh != null) result.speedKmh = speedKmh;
    return result;
  }

  VelocityData._();

  factory VelocityData.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VelocityData.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VelocityData',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vehicle_frame'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'speedMps', fieldType: $pb.PbFieldType.OF)
    ..aD(2, _omitFieldNames ? '' : 'speedKmh', fieldType: $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VelocityData clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VelocityData copyWith(void Function(VelocityData) updates) =>
      super.copyWith((message) => updates(message as VelocityData))
          as VelocityData;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VelocityData create() => VelocityData._();
  @$core.override
  VelocityData createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VelocityData getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VelocityData>(create);
  static VelocityData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get speedMps => $_getN(0);
  @$pb.TagNumber(1)
  set speedMps($core.double value) => $_setFloat(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSpeedMps() => $_has(0);
  @$pb.TagNumber(1)
  void clearSpeedMps() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get speedKmh => $_getN(1);
  @$pb.TagNumber(2)
  set speedKmh($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSpeedKmh() => $_has(1);
  @$pb.TagNumber(2)
  void clearSpeedKmh() => $_clearField(2);
}

class KinematicsData extends $pb.GeneratedMessage {
  factory KinematicsData({
    $core.double? accelMps2,
    $core.double? yawRate,
  }) {
    final result = create();
    if (accelMps2 != null) result.accelMps2 = accelMps2;
    if (yawRate != null) result.yawRate = yawRate;
    return result;
  }

  KinematicsData._();

  factory KinematicsData.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory KinematicsData.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'KinematicsData',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vehicle_frame'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'accelMps2', fieldType: $pb.PbFieldType.OF)
    ..aD(2, _omitFieldNames ? '' : 'yawRate', fieldType: $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KinematicsData clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KinematicsData copyWith(void Function(KinematicsData) updates) =>
      super.copyWith((message) => updates(message as KinematicsData))
          as KinematicsData;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static KinematicsData create() => KinematicsData._();
  @$core.override
  KinematicsData createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static KinematicsData getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<KinematicsData>(create);
  static KinematicsData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get accelMps2 => $_getN(0);
  @$pb.TagNumber(1)
  set accelMps2($core.double value) => $_setFloat(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAccelMps2() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccelMps2() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get yawRate => $_getN(1);
  @$pb.TagNumber(2)
  set yawRate($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(2)
  $core.bool hasYawRate() => $_has(1);
  @$pb.TagNumber(2)
  void clearYawRate() => $_clearField(2);
}

class MetricsData extends $pb.GeneratedMessage {
  factory MetricsData({
    $core.double? odometerM,
    $core.double? energyKwh,
  }) {
    final result = create();
    if (odometerM != null) result.odometerM = odometerM;
    if (energyKwh != null) result.energyKwh = energyKwh;
    return result;
  }

  MetricsData._();

  factory MetricsData.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MetricsData.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MetricsData',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vehicle_frame'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'odometerM', fieldType: $pb.PbFieldType.OF)
    ..aD(2, _omitFieldNames ? '' : 'energyKwh', fieldType: $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MetricsData clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MetricsData copyWith(void Function(MetricsData) updates) =>
      super.copyWith((message) => updates(message as MetricsData))
          as MetricsData;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MetricsData create() => MetricsData._();
  @$core.override
  MetricsData createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MetricsData getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MetricsData>(create);
  static MetricsData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get odometerM => $_getN(0);
  @$pb.TagNumber(1)
  set odometerM($core.double value) => $_setFloat(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOdometerM() => $_has(0);
  @$pb.TagNumber(1)
  void clearOdometerM() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get energyKwh => $_getN(1);
  @$pb.TagNumber(2)
  set energyKwh($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEnergyKwh() => $_has(1);
  @$pb.TagNumber(2)
  void clearEnergyKwh() => $_clearField(2);
}

class AdasSummary extends $pb.GeneratedMessage {
  factory AdasSummary({
    $core.int? obstacleCount,
    $core.bool? trafficLightRed,
    $core.bool? trafficLightYellow,
    $core.bool? trafficLightGreen,
    $core.int? pedestrianCount,
    $core.int? vehicleCount,
  }) {
    final result = create();
    if (obstacleCount != null) result.obstacleCount = obstacleCount;
    if (trafficLightRed != null) result.trafficLightRed = trafficLightRed;
    if (trafficLightYellow != null)
      result.trafficLightYellow = trafficLightYellow;
    if (trafficLightGreen != null) result.trafficLightGreen = trafficLightGreen;
    if (pedestrianCount != null) result.pedestrianCount = pedestrianCount;
    if (vehicleCount != null) result.vehicleCount = vehicleCount;
    return result;
  }

  AdasSummary._();

  factory AdasSummary.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AdasSummary.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AdasSummary',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vehicle_frame'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'obstacleCount',
        fieldType: $pb.PbFieldType.OU3)
    ..aOB(2, _omitFieldNames ? '' : 'trafficLightRed')
    ..aOB(3, _omitFieldNames ? '' : 'trafficLightYellow')
    ..aOB(4, _omitFieldNames ? '' : 'trafficLightGreen')
    ..aI(5, _omitFieldNames ? '' : 'pedestrianCount',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(6, _omitFieldNames ? '' : 'vehicleCount',
        fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdasSummary clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdasSummary copyWith(void Function(AdasSummary) updates) =>
      super.copyWith((message) => updates(message as AdasSummary))
          as AdasSummary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AdasSummary create() => AdasSummary._();
  @$core.override
  AdasSummary createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AdasSummary getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AdasSummary>(create);
  static AdasSummary? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get obstacleCount => $_getIZ(0);
  @$pb.TagNumber(1)
  set obstacleCount($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasObstacleCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearObstacleCount() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get trafficLightRed => $_getBF(1);
  @$pb.TagNumber(2)
  set trafficLightRed($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTrafficLightRed() => $_has(1);
  @$pb.TagNumber(2)
  void clearTrafficLightRed() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get trafficLightYellow => $_getBF(2);
  @$pb.TagNumber(3)
  set trafficLightYellow($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTrafficLightYellow() => $_has(2);
  @$pb.TagNumber(3)
  void clearTrafficLightYellow() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get trafficLightGreen => $_getBF(3);
  @$pb.TagNumber(4)
  set trafficLightGreen($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTrafficLightGreen() => $_has(3);
  @$pb.TagNumber(4)
  void clearTrafficLightGreen() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get pedestrianCount => $_getIZ(4);
  @$pb.TagNumber(5)
  set pedestrianCount($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPedestrianCount() => $_has(4);
  @$pb.TagNumber(5)
  void clearPedestrianCount() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get vehicleCount => $_getIZ(5);
  @$pb.TagNumber(6)
  set vehicleCount($core.int value) => $_setUnsignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasVehicleCount() => $_has(5);
  @$pb.TagNumber(6)
  void clearVehicleCount() => $_clearField(6);
}

class SurroundObject extends $pb.GeneratedMessage {
  factory SurroundObject({
    $core.double? x,
    $core.double? y,
    $core.double? vx,
    $core.double? vy,
    $core.String? type,
  }) {
    final result = create();
    if (x != null) result.x = x;
    if (y != null) result.y = y;
    if (vx != null) result.vx = vx;
    if (vy != null) result.vy = vy;
    if (type != null) result.type = type;
    return result;
  }

  SurroundObject._();

  factory SurroundObject.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SurroundObject.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SurroundObject',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vehicle_frame'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'x', fieldType: $pb.PbFieldType.OF)
    ..aD(2, _omitFieldNames ? '' : 'y', fieldType: $pb.PbFieldType.OF)
    ..aD(3, _omitFieldNames ? '' : 'vx', fieldType: $pb.PbFieldType.OF)
    ..aD(4, _omitFieldNames ? '' : 'vy', fieldType: $pb.PbFieldType.OF)
    ..aOS(5, _omitFieldNames ? '' : 'type')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SurroundObject clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SurroundObject copyWith(void Function(SurroundObject) updates) =>
      super.copyWith((message) => updates(message as SurroundObject))
          as SurroundObject;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SurroundObject create() => SurroundObject._();
  @$core.override
  SurroundObject createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SurroundObject getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SurroundObject>(create);
  static SurroundObject? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get x => $_getN(0);
  @$pb.TagNumber(1)
  set x($core.double value) => $_setFloat(0, value);
  @$pb.TagNumber(1)
  $core.bool hasX() => $_has(0);
  @$pb.TagNumber(1)
  void clearX() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get y => $_getN(1);
  @$pb.TagNumber(2)
  set y($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(2)
  $core.bool hasY() => $_has(1);
  @$pb.TagNumber(2)
  void clearY() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get vx => $_getN(2);
  @$pb.TagNumber(3)
  set vx($core.double value) => $_setFloat(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVx() => $_has(2);
  @$pb.TagNumber(3)
  void clearVx() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get vy => $_getN(3);
  @$pb.TagNumber(4)
  set vy($core.double value) => $_setFloat(3, value);
  @$pb.TagNumber(4)
  $core.bool hasVy() => $_has(3);
  @$pb.TagNumber(4)
  void clearVy() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get type => $_getSZ(4);
  @$pb.TagNumber(5)
  set type($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasType() => $_has(4);
  @$pb.TagNumber(5)
  void clearType() => $_clearField(5);
}

class EtaData extends $pb.GeneratedMessage {
  factory EtaData({
    $core.double? remainingDistanceM,
    $core.double? remainingTimeS,
  }) {
    final result = create();
    if (remainingDistanceM != null)
      result.remainingDistanceM = remainingDistanceM;
    if (remainingTimeS != null) result.remainingTimeS = remainingTimeS;
    return result;
  }

  EtaData._();

  factory EtaData.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EtaData.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EtaData',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vehicle_frame'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'remainingDistanceM',
        fieldType: $pb.PbFieldType.OF)
    ..aD(2, _omitFieldNames ? '' : 'remainingTimeS',
        fieldType: $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EtaData clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EtaData copyWith(void Function(EtaData) updates) =>
      super.copyWith((message) => updates(message as EtaData)) as EtaData;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EtaData create() => EtaData._();
  @$core.override
  EtaData createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EtaData getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EtaData>(create);
  static EtaData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get remainingDistanceM => $_getN(0);
  @$pb.TagNumber(1)
  set remainingDistanceM($core.double value) => $_setFloat(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRemainingDistanceM() => $_has(0);
  @$pb.TagNumber(1)
  void clearRemainingDistanceM() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get remainingTimeS => $_getN(1);
  @$pb.TagNumber(2)
  set remainingTimeS($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRemainingTimeS() => $_has(1);
  @$pb.TagNumber(2)
  void clearRemainingTimeS() => $_clearField(2);
}

class MrmState extends $pb.GeneratedMessage {
  factory MrmState({
    $core.bool? isActive,
    MrmBehavior? behavior,
    $core.String? description,
  }) {
    final result = create();
    if (isActive != null) result.isActive = isActive;
    if (behavior != null) result.behavior = behavior;
    if (description != null) result.description = description;
    return result;
  }

  MrmState._();

  factory MrmState.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MrmState.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MrmState',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vehicle_frame'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'isActive')
    ..aE<MrmBehavior>(2, _omitFieldNames ? '' : 'behavior',
        enumValues: MrmBehavior.values)
    ..aOS(3, _omitFieldNames ? '' : 'description')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MrmState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MrmState copyWith(void Function(MrmState) updates) =>
      super.copyWith((message) => updates(message as MrmState)) as MrmState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MrmState create() => MrmState._();
  @$core.override
  MrmState createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MrmState getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MrmState>(create);
  static MrmState? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get isActive => $_getBF(0);
  @$pb.TagNumber(1)
  set isActive($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIsActive() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsActive() => $_clearField(1);

  @$pb.TagNumber(2)
  MrmBehavior get behavior => $_getN(1);
  @$pb.TagNumber(2)
  set behavior(MrmBehavior value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasBehavior() => $_has(1);
  @$pb.TagNumber(2)
  void clearBehavior() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get description => $_getSZ(2);
  @$pb.TagNumber(3)
  set description($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDescription() => $_has(2);
  @$pb.TagNumber(3)
  void clearDescription() => $_clearField(3);
}

class VehicleFrame extends $pb.GeneratedMessage {
  factory VehicleFrame({
    $fixnum.Int64? stampNs,
    $fixnum.Int64? seq,
    VelocityData? velocity,
    MrmState? mrm,
    GearState? gear,
    $core.double? targetSpeedMps,
    TurnSignal? turnSignal,
    $core.Iterable<SurroundObject>? surroundObjects,
    $core.double? speedLimitMps,
    ControlMode? controlMode,
    AdasSummary? adas,
    KinematicsData? kinematics,
    MotionState? motionState,
    $core.double? steeringAngleDeg,
    $core.double? batteryPct,
    $core.bool? hazardOn,
    MetricsData? metrics,
    EtaData? eta,
  }) {
    final result = create();
    if (stampNs != null) result.stampNs = stampNs;
    if (seq != null) result.seq = seq;
    if (velocity != null) result.velocity = velocity;
    if (mrm != null) result.mrm = mrm;
    if (gear != null) result.gear = gear;
    if (targetSpeedMps != null) result.targetSpeedMps = targetSpeedMps;
    if (turnSignal != null) result.turnSignal = turnSignal;
    if (surroundObjects != null) result.surroundObjects.addAll(surroundObjects);
    if (speedLimitMps != null) result.speedLimitMps = speedLimitMps;
    if (controlMode != null) result.controlMode = controlMode;
    if (adas != null) result.adas = adas;
    if (kinematics != null) result.kinematics = kinematics;
    if (motionState != null) result.motionState = motionState;
    if (steeringAngleDeg != null) result.steeringAngleDeg = steeringAngleDeg;
    if (batteryPct != null) result.batteryPct = batteryPct;
    if (hazardOn != null) result.hazardOn = hazardOn;
    if (metrics != null) result.metrics = metrics;
    if (eta != null) result.eta = eta;
    return result;
  }

  VehicleFrame._();

  factory VehicleFrame.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VehicleFrame.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VehicleFrame',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vehicle_frame'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'stampNs')
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'seq', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<VelocityData>(3, _omitFieldNames ? '' : 'velocity',
        subBuilder: VelocityData.create)
    ..aOM<MrmState>(4, _omitFieldNames ? '' : 'mrm',
        subBuilder: MrmState.create)
    ..aE<GearState>(5, _omitFieldNames ? '' : 'gear',
        enumValues: GearState.values)
    ..aD(6, _omitFieldNames ? '' : 'targetSpeedMps',
        fieldType: $pb.PbFieldType.OF)
    ..aE<TurnSignal>(7, _omitFieldNames ? '' : 'turnSignal',
        enumValues: TurnSignal.values)
    ..pPM<SurroundObject>(8, _omitFieldNames ? '' : 'surroundObjects',
        subBuilder: SurroundObject.create)
    ..aD(9, _omitFieldNames ? '' : 'speedLimitMps',
        fieldType: $pb.PbFieldType.OF)
    ..aE<ControlMode>(10, _omitFieldNames ? '' : 'controlMode',
        enumValues: ControlMode.values)
    ..aOM<AdasSummary>(11, _omitFieldNames ? '' : 'adas',
        subBuilder: AdasSummary.create)
    ..aOM<KinematicsData>(12, _omitFieldNames ? '' : 'kinematics',
        subBuilder: KinematicsData.create)
    ..aE<MotionState>(13, _omitFieldNames ? '' : 'motionState',
        enumValues: MotionState.values)
    ..aD(14, _omitFieldNames ? '' : 'steeringAngleDeg',
        fieldType: $pb.PbFieldType.OF)
    ..aD(15, _omitFieldNames ? '' : 'batteryPct', fieldType: $pb.PbFieldType.OF)
    ..aOB(16, _omitFieldNames ? '' : 'hazardOn')
    ..aOM<MetricsData>(17, _omitFieldNames ? '' : 'metrics',
        subBuilder: MetricsData.create)
    ..aOM<EtaData>(18, _omitFieldNames ? '' : 'eta', subBuilder: EtaData.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VehicleFrame clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VehicleFrame copyWith(void Function(VehicleFrame) updates) =>
      super.copyWith((message) => updates(message as VehicleFrame))
          as VehicleFrame;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VehicleFrame create() => VehicleFrame._();
  @$core.override
  VehicleFrame createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VehicleFrame getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VehicleFrame>(create);
  static VehicleFrame? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get stampNs => $_getI64(0);
  @$pb.TagNumber(1)
  set stampNs($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStampNs() => $_has(0);
  @$pb.TagNumber(1)
  void clearStampNs() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get seq => $_getI64(1);
  @$pb.TagNumber(2)
  set seq($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSeq() => $_has(1);
  @$pb.TagNumber(2)
  void clearSeq() => $_clearField(2);

  /// 60 Hz sources
  @$pb.TagNumber(3)
  VelocityData get velocity => $_getN(2);
  @$pb.TagNumber(3)
  set velocity(VelocityData value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasVelocity() => $_has(2);
  @$pb.TagNumber(3)
  void clearVelocity() => $_clearField(3);
  @$pb.TagNumber(3)
  VelocityData ensureVelocity() => $_ensure(2);

  @$pb.TagNumber(4)
  MrmState get mrm => $_getN(3);
  @$pb.TagNumber(4)
  set mrm(MrmState value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasMrm() => $_has(3);
  @$pb.TagNumber(4)
  void clearMrm() => $_clearField(4);
  @$pb.TagNumber(4)
  MrmState ensureMrm() => $_ensure(3);

  /// 30 Hz sources
  @$pb.TagNumber(5)
  GearState get gear => $_getN(4);
  @$pb.TagNumber(5)
  set gear(GearState value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasGear() => $_has(4);
  @$pb.TagNumber(5)
  void clearGear() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get targetSpeedMps => $_getN(5);
  @$pb.TagNumber(6)
  set targetSpeedMps($core.double value) => $_setFloat(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTargetSpeedMps() => $_has(5);
  @$pb.TagNumber(6)
  void clearTargetSpeedMps() => $_clearField(6);

  @$pb.TagNumber(7)
  TurnSignal get turnSignal => $_getN(6);
  @$pb.TagNumber(7)
  set turnSignal(TurnSignal value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasTurnSignal() => $_has(6);
  @$pb.TagNumber(7)
  void clearTurnSignal() => $_clearField(7);

  /// 15 Hz sources
  @$pb.TagNumber(8)
  $pb.PbList<SurroundObject> get surroundObjects => $_getList(7);

  /// 10 Hz sources
  @$pb.TagNumber(9)
  $core.double get speedLimitMps => $_getN(8);
  @$pb.TagNumber(9)
  set speedLimitMps($core.double value) => $_setFloat(8, value);
  @$pb.TagNumber(9)
  $core.bool hasSpeedLimitMps() => $_has(8);
  @$pb.TagNumber(9)
  void clearSpeedLimitMps() => $_clearField(9);

  @$pb.TagNumber(10)
  ControlMode get controlMode => $_getN(9);
  @$pb.TagNumber(10)
  set controlMode(ControlMode value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasControlMode() => $_has(9);
  @$pb.TagNumber(10)
  void clearControlMode() => $_clearField(10);

  @$pb.TagNumber(11)
  AdasSummary get adas => $_getN(10);
  @$pb.TagNumber(11)
  set adas(AdasSummary value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasAdas() => $_has(10);
  @$pb.TagNumber(11)
  void clearAdas() => $_clearField(11);
  @$pb.TagNumber(11)
  AdasSummary ensureAdas() => $_ensure(10);

  /// async 50 Hz
  @$pb.TagNumber(12)
  KinematicsData get kinematics => $_getN(11);
  @$pb.TagNumber(12)
  set kinematics(KinematicsData value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasKinematics() => $_has(11);
  @$pb.TagNumber(12)
  void clearKinematics() => $_clearField(12);
  @$pb.TagNumber(12)
  KinematicsData ensureKinematics() => $_ensure(11);

  @$pb.TagNumber(13)
  MotionState get motionState => $_getN(12);
  @$pb.TagNumber(13)
  set motionState(MotionState value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasMotionState() => $_has(12);
  @$pb.TagNumber(13)
  void clearMotionState() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.double get steeringAngleDeg => $_getN(13);
  @$pb.TagNumber(14)
  set steeringAngleDeg($core.double value) => $_setFloat(13, value);
  @$pb.TagNumber(14)
  $core.bool hasSteeringAngleDeg() => $_has(13);
  @$pb.TagNumber(14)
  void clearSteeringAngleDeg() => $_clearField(14);

  /// 1 Hz sources
  @$pb.TagNumber(15)
  $core.double get batteryPct => $_getN(14);
  @$pb.TagNumber(15)
  set batteryPct($core.double value) => $_setFloat(14, value);
  @$pb.TagNumber(15)
  $core.bool hasBatteryPct() => $_has(14);
  @$pb.TagNumber(15)
  void clearBatteryPct() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.bool get hazardOn => $_getBF(15);
  @$pb.TagNumber(16)
  set hazardOn($core.bool value) => $_setBool(15, value);
  @$pb.TagNumber(16)
  $core.bool hasHazardOn() => $_has(15);
  @$pb.TagNumber(16)
  void clearHazardOn() => $_clearField(16);

  @$pb.TagNumber(17)
  MetricsData get metrics => $_getN(16);
  @$pb.TagNumber(17)
  set metrics(MetricsData value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasMetrics() => $_has(16);
  @$pb.TagNumber(17)
  void clearMetrics() => $_clearField(17);
  @$pb.TagNumber(17)
  MetricsData ensureMetrics() => $_ensure(16);

  @$pb.TagNumber(18)
  EtaData get eta => $_getN(17);
  @$pb.TagNumber(18)
  set eta(EtaData value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasEta() => $_has(17);
  @$pb.TagNumber(18)
  void clearEta() => $_clearField(18);
  @$pb.TagNumber(18)
  EtaData ensureEta() => $_ensure(17);
}

class SubscribeRequest extends $pb.GeneratedMessage {
  factory SubscribeRequest({
    $core.String? clientId,
  }) {
    final result = create();
    if (clientId != null) result.clientId = clientId;
    return result;
  }

  SubscribeRequest._();

  factory SubscribeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SubscribeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubscribeRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vehicle_frame'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'clientId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubscribeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubscribeRequest copyWith(void Function(SubscribeRequest) updates) =>
      super.copyWith((message) => updates(message as SubscribeRequest))
          as SubscribeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubscribeRequest create() => SubscribeRequest._();
  @$core.override
  SubscribeRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SubscribeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubscribeRequest>(create);
  static SubscribeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get clientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set clientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasClientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClientId() => $_clearField(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
