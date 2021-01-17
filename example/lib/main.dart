import 'package:flutter/material.dart';
import 'package:native_geocoder/native_geocoder.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: FutureBuilder<bool>(
            initialData: false,
            future: NativeGeocoder().isPresent,
            builder: (context, snapshot) => Text(
              snapshot.data ? 'Geocoder available' : 'Geocoder unavailable',
            ),
          ),
        ),
        body: Center(
          child: Container(
            child: FutureBuilder<List<Address>>(
              future: NativeGeocoder().getAddresses(
                53.55056883318608,
                9.991052363145235,
                maxResults: 5,
                locale: 'de_DE',
              ),
              builder: (context, snapshot) {
                final addresses = snapshot.data ?? <Address>[];

                if (addresses.isEmpty) {
                  return Text('No results');
                }

                return Column(
                  children: [
                    for (final addr in addresses)
                      ListTile(
                        title: Text(
                          addr.thoroughfare,
                        ),
                        subtitle: Text(
                          '${addr.latitude}, ${addr.longitude}',
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
