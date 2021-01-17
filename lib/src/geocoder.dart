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
  static const channel = MethodChannel('native_geocoder');

  @override
  Future<bool> get isPresent => channel.invokeMethod('is_present');

  @override
  Future<List<Address>> getAddresses(
    double latitude,
    double longitude, {
    int maxResults = 5,
    String locale,
  }) async {
    final List result = await channel.invokeMethod('get_addresses', {
      'latitude': latitude,
      'longtiude': longitude,
      'maxResults': maxResults,
      'locale': locale,
    });

    final a = result.map((addr) => Address.fromMap(addr)).toList();
    print(a);
    return a;
  }
}
