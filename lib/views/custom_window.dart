import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:kttask/views/draw_polyline.dart';
import '../utils/database_helper.dart';

class CustomWindow extends StatefulWidget {
  const CustomWindow({super.key, required this.user, required this.id});
  final String user;
  final int id;
  @override
  _CustomInfoWindowState createState() => _CustomInfoWindowState();
}

class _CustomInfoWindowState extends State<CustomWindow> {
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  List<Map<String, dynamic>> user = [];
  void getLocation() async {
    final data = await SQlMap.getCoordinate(widget.id);
    setState(() {
      user = data;
    });
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  final double _zoom = 15.0;

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  final Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    _markers.add(
      Marker(
        markerId: const MarkerId("marker_id"),
        position: LatLng(user.first["latitude"], user.first["longitude"]),
        onTap: () {
          _customInfoWindowController.addInfoWindow!(
            Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 30,
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            "Location",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  color: Colors.white,
                                ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.blue,
                  width: 20.0,
                  height: 10.0,
                ),
              ],
            ),
            LatLng(user.first["latitude"], user.first["longitude"]),
          );
        },
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("selected Location"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onTap: (position) {
              _customInfoWindowController.hideInfoWindow!();
            },
            onCameraMove: (position) {
              _customInfoWindowController.onCameraMove!();
            },
            onMapCreated: (GoogleMapController controller) async {
              _customInfoWindowController.googleMapController = controller;
            },
            markers: _markers,
            initialCameraPosition: CameraPosition(
              target: LatLng(user.first["latitude"], user.first["longitude"]),
              zoom: _zoom,
            ),
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 75,
            width: 150,
            offset: 50,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TrackingPage(
                      user: widget.user,
                    )),
          );
        },
        tooltip: 'playback',
        child: const Icon(Icons.play_circle),
      ),
    );
  }
}
