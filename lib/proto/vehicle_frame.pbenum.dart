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

import 'package:protobuf/protobuf.dart' as $pb;

class GearState extends $pb.ProtobufEnum {
  static const GearState GEAR_UNKNOWN =
      GearState._(0, _omitEnumNames ? '' : 'GEAR_UNKNOWN');
  static const GearState GEAR_PARK =
      GearState._(1, _omitEnumNames ? '' : 'GEAR_PARK');
  static const GearState GEAR_REVERSE =
      GearState._(2, _omitEnumNames ? '' : 'GEAR_REVERSE');
  static const GearState GEAR_NEUTRAL =
      GearState._(3, _omitEnumNames ? '' : 'GEAR_NEUTRAL');
  static const GearState GEAR_DRIVE =
      GearState._(4, _omitEnumNames ? '' : 'GEAR_DRIVE');

  static const $core.List<GearState> values = <GearState>[
    GEAR_UNKNOWN,
    GEAR_PARK,
    GEAR_REVERSE,
    GEAR_NEUTRAL,
    GEAR_DRIVE,
  ];

  static final $core.List<GearState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static GearState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const GearState._(super.value, super.name);
}

class TurnSignal extends $pb.ProtobufEnum {
  static const TurnSignal TURN_NONE =
      TurnSignal._(0, _omitEnumNames ? '' : 'TURN_NONE');
  static const TurnSignal TURN_LEFT =
      TurnSignal._(1, _omitEnumNames ? '' : 'TURN_LEFT');
  static const TurnSignal TURN_RIGHT =
      TurnSignal._(2, _omitEnumNames ? '' : 'TURN_RIGHT');

  static const $core.List<TurnSignal> values = <TurnSignal>[
    TURN_NONE,
    TURN_LEFT,
    TURN_RIGHT,
  ];

  static final $core.List<TurnSignal?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static TurnSignal? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TurnSignal._(super.value, super.name);
}

class ControlMode extends $pb.ProtobufEnum {
  static const ControlMode MODE_UNKNOWN =
      ControlMode._(0, _omitEnumNames ? '' : 'MODE_UNKNOWN');
  static const ControlMode MODE_MANUAL =
      ControlMode._(1, _omitEnumNames ? '' : 'MODE_MANUAL');
  static const ControlMode MODE_AUTO =
      ControlMode._(2, _omitEnumNames ? '' : 'MODE_AUTO');

  static const $core.List<ControlMode> values = <ControlMode>[
    MODE_UNKNOWN,
    MODE_MANUAL,
    MODE_AUTO,
  ];

  static final $core.List<ControlMode?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static ControlMode? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ControlMode._(super.value, super.name);
}

class MotionState extends $pb.ProtobufEnum {
  static const MotionState MOTION_UNKNOWN =
      MotionState._(0, _omitEnumNames ? '' : 'MOTION_UNKNOWN');
  static const MotionState MOTION_STOPPED =
      MotionState._(1, _omitEnumNames ? '' : 'MOTION_STOPPED');
  static const MotionState MOTION_MOVING =
      MotionState._(2, _omitEnumNames ? '' : 'MOTION_MOVING');
  static const MotionState MOTION_DECELERATING =
      MotionState._(3, _omitEnumNames ? '' : 'MOTION_DECELERATING');

  static const $core.List<MotionState> values = <MotionState>[
    MOTION_UNKNOWN,
    MOTION_STOPPED,
    MOTION_MOVING,
    MOTION_DECELERATING,
  ];

  static final $core.List<MotionState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static MotionState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const MotionState._(super.value, super.name);
}

class MrmBehavior extends $pb.ProtobufEnum {
  static const MrmBehavior MRM_NONE =
      MrmBehavior._(0, _omitEnumNames ? '' : 'MRM_NONE');
  static const MrmBehavior MRM_PULL_OVER =
      MrmBehavior._(1, _omitEnumNames ? '' : 'MRM_PULL_OVER');
  static const MrmBehavior MRM_EMERGENCY_STOP =
      MrmBehavior._(2, _omitEnumNames ? '' : 'MRM_EMERGENCY_STOP');

  static const $core.List<MrmBehavior> values = <MrmBehavior>[
    MRM_NONE,
    MRM_PULL_OVER,
    MRM_EMERGENCY_STOP,
  ];

  static final $core.List<MrmBehavior?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static MrmBehavior? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const MrmBehavior._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
