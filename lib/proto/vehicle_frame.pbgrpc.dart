// This is a generated file - do not edit.
//
// Generated from vehicle_frame.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'vehicle_frame.pb.dart' as $0;

export 'vehicle_frame.pb.dart';

@$pb.GrpcServiceName('vehicle_frame.ClusterService')
class ClusterServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  ClusterServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseStream<$0.VehicleFrame> subscribe(
    $0.SubscribeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$subscribe, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseFuture<$0.VehicleFrame> getLatestFrame(
    $0.SubscribeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getLatestFrame, request, options: options);
  }

  // method descriptors

  static final _$subscribe =
      $grpc.ClientMethod<$0.SubscribeRequest, $0.VehicleFrame>(
          '/vehicle_frame.ClusterService/Subscribe',
          ($0.SubscribeRequest value) => value.writeToBuffer(),
          $0.VehicleFrame.fromBuffer);
  static final _$getLatestFrame =
      $grpc.ClientMethod<$0.SubscribeRequest, $0.VehicleFrame>(
          '/vehicle_frame.ClusterService/GetLatestFrame',
          ($0.SubscribeRequest value) => value.writeToBuffer(),
          $0.VehicleFrame.fromBuffer);
}

@$pb.GrpcServiceName('vehicle_frame.ClusterService')
abstract class ClusterServiceBase extends $grpc.Service {
  $core.String get $name => 'vehicle_frame.ClusterService';

  ClusterServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.SubscribeRequest, $0.VehicleFrame>(
        'Subscribe',
        subscribe_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.SubscribeRequest.fromBuffer(value),
        ($0.VehicleFrame value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SubscribeRequest, $0.VehicleFrame>(
        'GetLatestFrame',
        getLatestFrame_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SubscribeRequest.fromBuffer(value),
        ($0.VehicleFrame value) => value.writeToBuffer()));
  }

  $async.Stream<$0.VehicleFrame> subscribe_Pre($grpc.ServiceCall $call,
      $async.Future<$0.SubscribeRequest> $request) async* {
    yield* subscribe($call, await $request);
  }

  $async.Stream<$0.VehicleFrame> subscribe(
      $grpc.ServiceCall call, $0.SubscribeRequest request);

  $async.Future<$0.VehicleFrame> getLatestFrame_Pre($grpc.ServiceCall $call,
      $async.Future<$0.SubscribeRequest> $request) async {
    return getLatestFrame($call, await $request);
  }

  $async.Future<$0.VehicleFrame> getLatestFrame(
      $grpc.ServiceCall call, $0.SubscribeRequest request);
}
