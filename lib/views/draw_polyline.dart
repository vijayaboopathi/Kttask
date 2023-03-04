import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import '../utils/database_helper.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage({super.key, required this.user});
  final String user;
  @override
  State<TrackingPage> createState() => TrackingPageState();
}

class TrackingPageState extends State<TrackingPage> {
  final Completer<GoogleMapController> _controller = Completer();
  List<LatLng> polylineCoordinates = [];
  List<Map<String, dynamic>> user = [];

  Set<Marker> markers = {};

  void _refreshCoordinates() async {
    final data = await SQlMap.getCoordinates(widget.user);
    setState(() {
      user = data;
    });
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyDees4_5MN91I822aqQeWlwklp2uC5Ypts", // Your Google Map Key
      PointLatLng(user.first["latitude"], user.first["longitude"]),
      PointLatLng(user.last["latitude"], user.last["longitude"]),
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        );
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    _refreshCoordinates();
    getPolyPoints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Draw Polyline"),
        centerTitle: true,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(user.first["latitude"], user.first["longitude"]),
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: const MarkerId("source"),
            position: LatLng(user.first["latitude"], user.first["longitude"]),
          ),
          Marker(
            markerId: const MarkerId("destination"),
            position: LatLng(user.last["latitude"], user.last["longitude"]),
          ),
        },
        onMapCreated: (mapController) {
          _controller.complete(mapController);
        },
        polylines: {
          Polyline(
            polylineId: const PolylineId("poly"),
            points: polylineCoordinates,
            color: Colors.red,
            width: 5,
          ),
        },
      ),
    );
  }
}
