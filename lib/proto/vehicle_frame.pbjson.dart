// This is a generated file - do not edit.
//
// Generated from vehicle_frame.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use gearStateDescriptor instead')
const GearState$json = {
  '1': 'GearState',
  '2': [
    {'1': 'GEAR_UNKNOWN', '2': 0},
    {'1': 'GEAR_PARK', '2': 1},
    {'1': 'GEAR_REVERSE', '2': 2},
    {'1': 'GEAR_NEUTRAL', '2': 3},
    {'1': 'GEAR_DRIVE', '2': 4},
  ],
};

/// Descriptor for `GearState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List gearStateDescriptor = $convert.base64Decode(
    'CglHZWFyU3RhdGUSEAoMR0VBUl9VTktOT1dOEAASDQoJR0VBUl9QQVJLEAESEAoMR0VBUl9SRV'
    'ZFUlNFEAISEAoMR0VBUl9ORVVUUkFMEAMSDgoKR0VBUl9EUklWRRAE');

@$core.Deprecated('Use turnSignalDescriptor instead')
const TurnSignal$json = {
  '1': 'TurnSignal',
  '2': [
    {'1': 'TURN_NONE', '2': 0},
    {'1': 'TURN_LEFT', '2': 1},
    {'1': 'TURN_RIGHT', '2': 2},
  ],
};

/// Descriptor for `TurnSignal`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List turnSignalDescriptor = $convert.base64Decode(
    'CgpUdXJuU2lnbmFsEg0KCVRVUk5fTk9ORRAAEg0KCVRVUk5fTEVGVBABEg4KClRVUk5fUklHSF'
    'QQAg==');

@$core.Deprecated('Use controlModeDescriptor instead')
const ControlMode$json = {
  '1': 'ControlMode',
  '2': [
    {'1': 'MODE_UNKNOWN', '2': 0},
    {'1': 'MODE_MANUAL', '2': 1},
    {'1': 'MODE_AUTO', '2': 2},
  ],
};

/// Descriptor for `ControlMode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List controlModeDescriptor = $convert.base64Decode(
    'CgtDb250cm9sTW9kZRIQCgxNT0RFX1VOS05PV04QABIPCgtNT0RFX01BTlVBTBABEg0KCU1PRE'
    'VfQVVUTxAC');

@$core.Deprecated('Use motionStateDescriptor instead')
const MotionState$json = {
  '1': 'MotionState',
  '2': [
    {'1': 'MOTION_UNKNOWN', '2': 0},
    {'1': 'MOTION_STOPPED', '2': 1},
    {'1': 'MOTION_MOVING', '2': 2},
    {'1': 'MOTION_DECELERATING', '2': 3},
  ],
};

/// Descriptor for `MotionState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List motionStateDescriptor = $convert.base64Decode(
    'CgtNb3Rpb25TdGF0ZRISCg5NT1RJT05fVU5LTk9XThAAEhIKDk1PVElPTl9TVE9QUEVEEAESEQ'
    'oNTU9USU9OX01PVklORxACEhcKE01PVElPTl9ERUNFTEVSQVRJTkcQAw==');

@$core.Deprecated('Use mrmBehaviorDescriptor instead')
const MrmBehavior$json = {
  '1': 'MrmBehavior',
  '2': [
    {'1': 'MRM_NONE', '2': 0},
    {'1': 'MRM_PULL_OVER', '2': 1},
    {'1': 'MRM_EMERGENCY_STOP', '2': 2},
  ],
};

/// Descriptor for `MrmBehavior`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List mrmBehaviorDescriptor = $convert.base64Decode(
    'CgtNcm1CZWhhdmlvchIMCghNUk1fTk9ORRAAEhEKDU1STV9QVUxMX09WRVIQARIWChJNUk1fRU'
    '1FUkdFTkNZX1NUT1AQAg==');

@$core.Deprecated('Use velocityDataDescriptor instead')
const VelocityData$json = {
  '1': 'VelocityData',
  '2': [
    {'1': 'speed_mps', '3': 1, '4': 1, '5': 2, '10': 'speedMps'},
    {'1': 'speed_kmh', '3': 2, '4': 1, '5': 2, '10': 'speedKmh'},
  ],
};

/// Descriptor for `VelocityData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List velocityDataDescriptor = $convert.base64Decode(
    'CgxWZWxvY2l0eURhdGESGwoJc3BlZWRfbXBzGAEgASgCUghzcGVlZE1wcxIbCglzcGVlZF9rbW'
    'gYAiABKAJSCHNwZWVkS21o');

@$core.Deprecated('Use kinematicsDataDescriptor instead')
const KinematicsData$json = {
  '1': 'KinematicsData',
  '2': [
    {'1': 'accel_mps2', '3': 1, '4': 1, '5': 2, '10': 'accelMps2'},
    {'1': 'yaw_rate', '3': 2, '4': 1, '5': 2, '10': 'yawRate'},
  ],
};

/// Descriptor for `KinematicsData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List kinematicsDataDescriptor = $convert.base64Decode(
    'Cg5LaW5lbWF0aWNzRGF0YRIdCgphY2NlbF9tcHMyGAEgASgCUglhY2NlbE1wczISGQoIeWF3X3'
    'JhdGUYAiABKAJSB3lhd1JhdGU=');

@$core.Deprecated('Use metricsDataDescriptor instead')
const MetricsData$json = {
  '1': 'MetricsData',
  '2': [
    {'1': 'odometer_m', '3': 1, '4': 1, '5': 2, '10': 'odometerM'},
    {'1': 'energy_kwh', '3': 2, '4': 1, '5': 2, '10': 'energyKwh'},
  ],
};

/// Descriptor for `MetricsData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List metricsDataDescriptor = $convert.base64Decode(
    'CgtNZXRyaWNzRGF0YRIdCgpvZG9tZXRlcl9tGAEgASgCUglvZG9tZXRlck0SHQoKZW5lcmd5X2'
    't3aBgCIAEoAlIJZW5lcmd5S3do');

@$core.Deprecated('Use adasSummaryDescriptor instead')
const AdasSummary$json = {
  '1': 'AdasSummary',
  '2': [
    {'1': 'obstacle_count', '3': 1, '4': 1, '5': 13, '10': 'obstacleCount'},
    {'1': 'traffic_light_red', '3': 2, '4': 1, '5': 8, '10': 'trafficLightRed'},
    {
      '1': 'traffic_light_yellow',
      '3': 3,
      '4': 1,
      '5': 8,
      '10': 'trafficLightYellow'
    },
    {
      '1': 'traffic_light_green',
      '3': 4,
      '4': 1,
      '5': 8,
      '10': 'trafficLightGreen'
    },
    {'1': 'pedestrian_count', '3': 5, '4': 1, '5': 13, '10': 'pedestrianCount'},
    {'1': 'vehicle_count', '3': 6, '4': 1, '5': 13, '10': 'vehicleCount'},
  ],
};

/// Descriptor for `AdasSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List adasSummaryDescriptor = $convert.base64Decode(
    'CgtBZGFzU3VtbWFyeRIlCg5vYnN0YWNsZV9jb3VudBgBIAEoDVINb2JzdGFjbGVDb3VudBIqCh'
    'F0cmFmZmljX2xpZ2h0X3JlZBgCIAEoCFIPdHJhZmZpY0xpZ2h0UmVkEjAKFHRyYWZmaWNfbGln'
    'aHRfeWVsbG93GAMgASgIUhJ0cmFmZmljTGlnaHRZZWxsb3cSLgoTdHJhZmZpY19saWdodF9ncm'
    'VlbhgEIAEoCFIRdHJhZmZpY0xpZ2h0R3JlZW4SKQoQcGVkZXN0cmlhbl9jb3VudBgFIAEoDVIP'
    'cGVkZXN0cmlhbkNvdW50EiMKDXZlaGljbGVfY291bnQYBiABKA1SDHZlaGljbGVDb3VudA==');

@$core.Deprecated('Use surroundObjectDescriptor instead')
const SurroundObject$json = {
  '1': 'SurroundObject',
  '2': [
    {'1': 'x', '3': 1, '4': 1, '5': 2, '10': 'x'},
    {'1': 'y', '3': 2, '4': 1, '5': 2, '10': 'y'},
    {'1': 'vx', '3': 3, '4': 1, '5': 2, '10': 'vx'},
    {'1': 'vy', '3': 4, '4': 1, '5': 2, '10': 'vy'},
    {'1': 'type', '3': 5, '4': 1, '5': 9, '10': 'type'},
  ],
};

/// Descriptor for `SurroundObject`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List surroundObjectDescriptor = $convert.base64Decode(
    'Cg5TdXJyb3VuZE9iamVjdBIMCgF4GAEgASgCUgF4EgwKAXkYAiABKAJSAXkSDgoCdngYAyABKA'
    'JSAnZ4Eg4KAnZ5GAQgASgCUgJ2eRISCgR0eXBlGAUgASgJUgR0eXBl');

@$core.Deprecated('Use etaDataDescriptor instead')
const EtaData$json = {
  '1': 'EtaData',
  '2': [
    {
      '1': 'remaining_distance_m',
      '3': 1,
      '4': 1,
      '5': 2,
      '10': 'remainingDistanceM'
    },
    {'1': 'remaining_time_s', '3': 2, '4': 1, '5': 2, '10': 'remainingTimeS'},
  ],
};

/// Descriptor for `EtaData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List etaDataDescriptor = $convert.base64Decode(
    'CgdFdGFEYXRhEjAKFHJlbWFpbmluZ19kaXN0YW5jZV9tGAEgASgCUhJyZW1haW5pbmdEaXN0YW'
    '5jZU0SKAoQcmVtYWluaW5nX3RpbWVfcxgCIAEoAlIOcmVtYWluaW5nVGltZVM=');

@$core.Deprecated('Use mrmStateDescriptor instead')
const MrmState$json = {
  '1': 'MrmState',
  '2': [
    {'1': 'is_active', '3': 1, '4': 1, '5': 8, '10': 'isActive'},
    {
      '1': 'behavior',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.vehicle_frame.MrmBehavior',
      '10': 'behavior'
    },
    {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
  ],
};

/// Descriptor for `MrmState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mrmStateDescriptor = $convert.base64Decode(
    'CghNcm1TdGF0ZRIbCglpc19hY3RpdmUYASABKAhSCGlzQWN0aXZlEjYKCGJlaGF2aW9yGAIgAS'
    'gOMhoudmVoaWNsZV9mcmFtZS5Ncm1CZWhhdmlvclIIYmVoYXZpb3ISIAoLZGVzY3JpcHRpb24Y'
    'AyABKAlSC2Rlc2NyaXB0aW9u');

@$core.Deprecated('Use vehicleFrameDescriptor instead')
const VehicleFrame$json = {
  '1': 'VehicleFrame',
  '2': [
    {'1': 'stamp_ns', '3': 1, '4': 1, '5': 3, '10': 'stampNs'},
    {'1': 'seq', '3': 2, '4': 1, '5': 4, '10': 'seq'},
    {
      '1': 'velocity',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.vehicle_frame.VelocityData',
      '10': 'velocity'
    },
    {
      '1': 'mrm',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.vehicle_frame.MrmState',
      '10': 'mrm'
    },
    {
      '1': 'gear',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.vehicle_frame.GearState',
      '10': 'gear'
    },
    {'1': 'target_speed_mps', '3': 6, '4': 1, '5': 2, '10': 'targetSpeedMps'},
    {
      '1': 'turn_signal',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.vehicle_frame.TurnSignal',
      '10': 'turnSignal'
    },
    {
      '1': 'surround_objects',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.vehicle_frame.SurroundObject',
      '10': 'surroundObjects'
    },
    {'1': 'speed_limit_mps', '3': 9, '4': 1, '5': 2, '10': 'speedLimitMps'},
    {
      '1': 'control_mode',
      '3': 10,
      '4': 1,
      '5': 14,
      '6': '.vehicle_frame.ControlMode',
      '10': 'controlMode'
    },
    {
      '1': 'adas',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.vehicle_frame.AdasSummary',
      '10': 'adas'
    },
    {
      '1': 'kinematics',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.vehicle_frame.KinematicsData',
      '10': 'kinematics'
    },
    {
      '1': 'motion_state',
      '3': 13,
      '4': 1,
      '5': 14,
      '6': '.vehicle_frame.MotionState',
      '10': 'motionState'
    },
    {
      '1': 'steering_angle_deg',
      '3': 14,
      '4': 1,
      '5': 2,
      '10': 'steeringAngleDeg'
    },
    {'1': 'battery_pct', '3': 15, '4': 1, '5': 2, '10': 'batteryPct'},
    {'1': 'hazard_on', '3': 16, '4': 1, '5': 8, '10': 'hazardOn'},
    {
      '1': 'metrics',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.vehicle_frame.MetricsData',
      '10': 'metrics'
    },
    {
      '1': 'eta',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.vehicle_frame.EtaData',
      '10': 'eta'
    },
  ],
};

/// Descriptor for `VehicleFrame`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List vehicleFrameDescriptor = $convert.base64Decode(
    'CgxWZWhpY2xlRnJhbWUSGQoIc3RhbXBfbnMYASABKANSB3N0YW1wTnMSEAoDc2VxGAIgASgEUg'
    'NzZXESNwoIdmVsb2NpdHkYAyABKAsyGy52ZWhpY2xlX2ZyYW1lLlZlbG9jaXR5RGF0YVIIdmVs'
    'b2NpdHkSKQoDbXJtGAQgASgLMhcudmVoaWNsZV9mcmFtZS5Ncm1TdGF0ZVIDbXJtEiwKBGdlYX'
    'IYBSABKA4yGC52ZWhpY2xlX2ZyYW1lLkdlYXJTdGF0ZVIEZ2VhchIoChB0YXJnZXRfc3BlZWRf'
    'bXBzGAYgASgCUg50YXJnZXRTcGVlZE1wcxI6Cgt0dXJuX3NpZ25hbBgHIAEoDjIZLnZlaGljbG'
    'VfZnJhbWUuVHVyblNpZ25hbFIKdHVyblNpZ25hbBJIChBzdXJyb3VuZF9vYmplY3RzGAggAygL'
    'Mh0udmVoaWNsZV9mcmFtZS5TdXJyb3VuZE9iamVjdFIPc3Vycm91bmRPYmplY3RzEiYKD3NwZW'
    'VkX2xpbWl0X21wcxgJIAEoAlINc3BlZWRMaW1pdE1wcxI9Cgxjb250cm9sX21vZGUYCiABKA4y'
    'Gi52ZWhpY2xlX2ZyYW1lLkNvbnRyb2xNb2RlUgtjb250cm9sTW9kZRIuCgRhZGFzGAsgASgLMh'
    'oudmVoaWNsZV9mcmFtZS5BZGFzU3VtbWFyeVIEYWRhcxI9CgpraW5lbWF0aWNzGAwgASgLMh0u'
    'dmVoaWNsZV9mcmFtZS5LaW5lbWF0aWNzRGF0YVIKa2luZW1hdGljcxI9Cgxtb3Rpb25fc3RhdG'
    'UYDSABKA4yGi52ZWhpY2xlX2ZyYW1lLk1vdGlvblN0YXRlUgttb3Rpb25TdGF0ZRIsChJzdGVl'
    'cmluZ19hbmdsZV9kZWcYDiABKAJSEHN0ZWVyaW5nQW5nbGVEZWcSHwoLYmF0dGVyeV9wY3QYDy'
    'ABKAJSCmJhdHRlcnlQY3QSGwoJaGF6YXJkX29uGBAgASgIUghoYXphcmRPbhI0CgdtZXRyaWNz'
    'GBEgASgLMhoudmVoaWNsZV9mcmFtZS5NZXRyaWNzRGF0YVIHbWV0cmljcxIoCgNldGEYEiABKA'
    'syFi52ZWhpY2xlX2ZyYW1lLkV0YURhdGFSA2V0YQ==');

@$core.Deprecated('Use subscribeRequestDescriptor instead')
const SubscribeRequest$json = {
  '1': 'SubscribeRequest',
  '2': [
    {'1': 'client_id', '3': 1, '4': 1, '5': 9, '10': 'clientId'},
  ],
};

/// Descriptor for `SubscribeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subscribeRequestDescriptor = $convert.base64Decode(
    'ChBTdWJzY3JpYmVSZXF1ZXN0EhsKCWNsaWVudF9pZBgBIAEoCVIIY2xpZW50SWQ=');
