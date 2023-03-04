import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kttask/views/custom_window.dart';
import 'package:kttask/views/login_page.dart';
import 'package:location/location.dart';
import '../utils/database_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.user});
  final String user;
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Location location = Location();
  late bool _serviceEnabled;
  late PermissionStatus permissionGranted;
  late LocationData liveLocation;
  bool getLocation = false;
  bool _isLoading = true;
  List<Map<String, dynamic>> user = [];
  Timer? timer;

  void getPermission() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (_serviceEnabled) return;
    }
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }
    liveLocation = await location.getLocation();
    setState(() {
      getLocation = true;
    });
  }

  Future<void> storeLocation(dynamic latitude, dynamic longitude) async {
    await SQlMap.createCoordinates(widget.user, latitude, longitude);
  }

  void _refreshCoordinates() async {
    final data = await SQlMap.getCoordinates(widget.user);
    setState(() {
      user = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getPermission(); // Loading the diary when the app starts
    timer = Timer.periodic(const Duration(minutes: 1), (timer) async {
      liveLocation = await location.getLocation();
      storeLocation(liveLocation.latitude, liveLocation.longitude);
      _refreshCoordinates();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () => getPermission(),
              icon: const Icon(
                Icons.location_on,
                color: Colors.white,
              ))
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : getLocation
              ? ListView.builder(
                  itemCount: user.length,
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (context, index) => ListTile(
                        leading: const Icon(Icons.location_on),
                        title: Text(
                            'Location: ${user[index]["latitude"]} / ${user[index]["longitude"]}'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                     CustomWindow(user: widget.user,id: index,)),
                          );
                        },
                      ))
              : Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          timer!.cancel();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        },
        tooltip: 'switch Account',
        child: const Icon(Icons.switch_account),
      ),
    );
  }
}
