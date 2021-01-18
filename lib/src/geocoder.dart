import 'dart:async';

import 'package:flutter/services.dart';

import 'address.dart';

abstract class NativeGeocoder {
  factory NativeGeocoder() => _NativeGeocoderImpl();

  Future<bool> get isPresent;

  Future<List<Address>> getAddresses(
    double latitude,
    double longitude, {
    int maxResults = 5,
    String locale,
  });
}

class _NativeGeocoderImpl implements NativeGeocoder {
  _NativeGeocoderImpl() {
    channel.setMethodCallHandler(onMethodCall);
  }

  static const channel = MethodChannel('native_geocoder');

  Completer<List<Address>> _completer;

  @override
  Future<bool> get isPresent => channel.invokeMethod('is_present');

  @override
  Future<List<Address>> getAddresses(
    double latitude,
    double longitude, {
    int maxResults = 5,
    String locale,
  }) async {
    _completer?.complete(<Address>[]);
    _completer = Completer();

    final List r = await channel.invokeMethod('get_addresses', {
      'latitude': latitude,
      'longtiude': longitude,
      'maxResults': maxResults,
      'locale': locale,
    });

    return r.map((addr) => Address.fromMap(addr)).toList();
  }

  Future<void> onMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'on_addresses':
        print(call.arguments);
        final result = call.arguments.map((addr) => Address.fromMap(addr)).toList();
        _completer.complete(result);
        break;
    }
  }
}
