import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geo_locator_app/screen/details.dart';
import 'package:geo_locator_app/screen/details_screen.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utility/local_storage.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  StreamSubscription<Position>? positionStream;

  Position? userLocation;
  double latitude = 12.97052;
  double longitude = 80.2502;

  final List<Marker> markers = <Marker>[];

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
    });
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  @override
  void initState() {
    getLocation();
    super.initState();
  }

  getLocation() async {
    getUserCurrentLocation().then((value) async {
      longitude = value.longitude;
      latitude = value.latitude;
      // marker added for current users location
      markers.add(Marker(
        markerId: const MarkerId("2"),
        position: LatLng(value.latitude, value.longitude),
        infoWindow: const InfoWindow(
          title: 'My Current Location',
        ),
      ));

      // specified current users location
      CameraPosition cameraPosition = CameraPosition(
        target: LatLng(value.latitude, value.longitude),
        zoom: 14,
      );

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        // on below line we have given title of app
        title: const Text("Map"),
      ),
      body: SafeArea(
        // on below line creating google maps
        child: GoogleMap(
          onTap: (argument) async {
            markers.add(Marker(
              markerId: const MarkerId("2"),
              position: LatLng(argument.latitude, argument.longitude),
              infoWindow: const InfoWindow(
                title: 'My Current Location',
              ),
            ));
            CameraPosition cameraPosition = CameraPosition(
              target: LatLng(argument.latitude, argument.longitude),
              zoom: 14,
            );

            final GoogleMapController controller = await _controller.future;
            controller
                .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
            setState(() {
              longitude = argument.longitude;
              latitude = argument.latitude;
            });
          },

          // on below line setting camera position
          initialCameraPosition: CameraPosition(
            target: LatLng(latitude, longitude),
            zoom: 14.4746,
          ),
          // on below line we are setting markers on the map
          markers: Set<Marker>.of(markers),
          // on below line specifying map type.
          mapType: MapType.normal,
          // on below line setting user location enabled.
          myLocationEnabled: true,
          // on below line setting compass enabled.
          compassEnabled: true,
          // on below line specifying controller on map complete.
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
      // on pressing floating action button the camera will take to user current location
      floatingActionButton: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 24),
          child: FloatingActionButton(
            onPressed: () async {
              List<Placemark> place =
                  await placemarkFromCoordinates(latitude, longitude);
              final String address =
                  "${place[2].name!} ${place[2].subLocality.toString()} ${place[2].locality.toString()}.${place[2].administrativeArea.toString()}-${place[2].postalCode.toString()}-${place[2].country.toString()}.";

              SharedPreferences prefs = await SharedPreferences.getInstance();

              await prefs.setString(SharedKeyConstant.ADDRESS, address);
              if (context.mounted) {}
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const DetailsScreen()));
            },
            child: const Icon(Icons.send),
          ),
        ),
      ),
    );
  }
}
