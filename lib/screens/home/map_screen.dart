import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key, required this.coordinates}) : super(key: key);
  final Map coordinates;

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  Marker marker = Marker(markerId: MarkerId('getLoactionMarker'));
  Map location = {};

  late final CameraPosition _initialLoaction = CameraPosition(
    target: LatLng(widget.coordinates['lat'] ?? 30.4167,
        widget.coordinates['lng'] ?? -9.5833),
    zoom: 12.0,
  );

  void createMarker(val) {
    setState(() {
      marker = Marker(
        markerId: MarkerId('getLoactionMarker'),
        infoWindow: InfoWindow(title: "You are here"),
        icon: BitmapDescriptor.defaultMarker,
        position: val,
      );
      location = {
        "lat": marker.position.latitude,
        "lng": marker.position.longitude
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _initialLoaction,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: {marker},
        onTap: createMarker,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pop(context, location);
        },
        label: Text('Done'),
        icon: Icon(Icons.done),
      ),
    );
  }

  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  // }
}
