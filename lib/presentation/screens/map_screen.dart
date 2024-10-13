import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        markers: {
          Marker(
              markerId: MarkerId('value'),
              position: LatLng(42.87437, 74.603548),
              infoWindow: InfoWindow(
                  title: 'Памятник Ч. Айтматову',
                  onTap: () {
                    print('object');
                  })),
        },
        mapType: MapType.normal,
        zoomControlsEnabled: false,
        initialCameraPosition: const CameraPosition(
          target: LatLng(42.8746, 74.5698),
          zoom: 11.4746,
        ),
        onMapCreated: (GoogleMapController mapController) {},
      ),
    );
  }
}
