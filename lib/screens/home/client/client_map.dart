import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClientMap extends StatefulWidget {
  const ClientMap({Key? key, required this.coordinates}) : super(key: key);
  final Map coordinates;

  @override
  _ClientMapState createState() => _ClientMapState();
}

class _ClientMapState extends State<ClientMap> {
  Completer<GoogleMapController> _controller = Completer();
  Marker marker = Marker(
      markerId: MarkerId(
    'getLoactionMarker',
  ));
  Map location = {};

  late final CameraPosition _initialLoaction = CameraPosition(
    target: LatLng(widget.coordinates['lat'] ?? 30.4167,
        widget.coordinates['lng'] ?? -9.5833),
    zoom: 15.0,
  );

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("client Location"),
        backgroundColor: Colors.blueGrey,
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _initialLoaction,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: {
          Marker(
            markerId: MarkerId("theclinetlocation"),
            infoWindow: InfoWindow(title: "You are here"),
            icon: BitmapDescriptor.defaultMarker,
            position:
                LatLng(widget.coordinates['lat'], widget.coordinates['lng']),
          )
        },
      ),
    );
  }

  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  // }
}
