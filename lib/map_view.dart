import 'dart:async';

import 'package:delvr_demo_3/methods.dart';
import 'package:delvr_demo_3/notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:latlong2/latlong.dart' as ll;
import 'package:shared_preferences/shared_preferences.dart';
import 'objects.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/services.dart' show rootBundle;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class MapView extends StatefulWidget {
  const MapView(
      {
        Key? key,
        required this.customInfoWindowController,
        required this.places,
        required this.icons,
        required this.allPlaces
      })
      : super(key: key);

  final CustomInfoWindowController customInfoWindowController;

  final List<Place> places;
  final List<BitmapDescriptor> icons;
  final List<Place> allPlaces;

  @override
  State<MapView> createState() => _MapState();
}

class _MapState extends State<MapView> {
  LocationData? currentLocation;

  String _mapStyle = "";
  final defaultLocation = const LatLng(60.18605610971214, 24.827084739647233);

  // Get current user location and update it
  void getCurrentLocation() {
    Location location = Location();

    location.enableBackgroundMode(enable: true);

    location.getLocation().then(
      (location) {
        currentLocation = location;
        // Sets camera to real location when one is available
        _goToCurrentLoc();
      },
    );
    location.onLocationChanged.listen(
      (newloc) {
        currentLocation = newloc;

        location.changeNotificationOptions(
          title: 'Geolocation',
          subtitle:
              '${currentLocation?.latitude}, ${currentLocation?.longitude}',
          onTapBringToFront: true,
        );

        setState(() {
          notify();
        });
      },
    );
  }

  List<Place> currentNearPlaces = [];

  void notify() async {

    // Get preferred settings for notifications. If not set, defaults are used
    final prefs = await SharedPreferences.getInstance();
    final distance = prefs.getDouble('distance') ?? 50.0;
    final sound = prefs.getBool('sound') ?? true;
    final vibrate = prefs.getBool('vibrate') ?? true;

    // Loop through places and check if one is closer than 50 m. If so, send a notification
    for (Place place in widget.allPlaces) {
      var user = LatLng(currentLocation!.latitude!, currentLocation!.longitude!);
      var dist = getDistance(user, place.getLoc());
      if( await Methods.notifyForPlace(place) ){
        if (dist < distance && !currentNearPlaces.contains(place)) {
          currentNearPlaces.add(place);
          String placeTitles = "";
          for (Place place in currentNearPlaces) {
            placeTitles += '${place.title}, ';
          }
          // Call a decide function that determines which sort of notification should be sent
          Methods.decideNoti(sound, vibrate, 'Discounts nearby!', 'Discounts at: $placeTitles', flutterLocalNotificationsPlugin);
        }
      }
      if (dist >= distance && currentNearPlaces.contains(place)) {
        currentNearPlaces.remove(place);
      }
    }
  }

  final ll.Distance distance = const ll.Distance();

  // Helper function for calculating distance between two coordinates
  double getDistance(LatLng user, LatLng dest) {
    var u = ll.LatLng(user.latitude, user.longitude);
    var d = ll.LatLng(dest.latitude, dest.longitude);
    return distance(u, d);
  }

  @override
  void initState() {
    getCurrentLocation();
    // Init all notification types
    SoundNoti.initialize(flutterLocalNotificationsPlugin);
    SilentNoti.initialize(flutterLocalNotificationsPlugin);
    VibrateNoti.initialize(flutterLocalNotificationsPlugin);
    OnlySoundNoti.initialize(flutterLocalNotificationsPlugin);
    super.initState();
    rootBundle.loadString('android/assets/map_style.txt').then((string){
      setState(() {
        _mapStyle = string;
      });
    });
  }

  final Completer<GoogleMapController> _gController = Completer<GoogleMapController>();

  // Moves camera to current location
  Future<void> _goToCurrentLoc() async {
    CameraPosition curPos = CameraPosition(
        target: currentLocation == null
            ? defaultLocation
            : LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
        zoom: 14.5,
    );
    final GoogleMapController gController = await _gController.future;
    gController.animateCamera(CameraUpdate.newCameraPosition(curPos));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                      // Default to Otaniemi if location is unavailable
                      target: currentLocation == null
                          ? defaultLocation
                          : LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
                      zoom: 14.5),

                  // Set of all markers in the map
                  markers: Set<Marker>.from(Methods.loadData(widget.places, widget.customInfoWindowController, context, widget.icons)).union({
                    Marker(
                        markerId: const MarkerId("curloc"),
                        // Default to Otaniemi if location is unavailable
                        position: currentLocation == null
                            ? defaultLocation
                            : LatLng(currentLocation!.latitude!, currentLocation!.longitude!)
                    )
                  }),
                  onTap: (position) {
                    widget.customInfoWindowController.hideInfoWindow!();
                  },
                  onCameraMove: (position) {
                    widget.customInfoWindowController.onCameraMove!();
                  },
                  onMapCreated: (GoogleMapController controller) {
                    widget.customInfoWindowController.googleMapController =
                        controller;
                    _gController.complete(controller);
                    controller.setMapStyle(_mapStyle);
                  },
                ),
                CustomInfoWindow(
                  controller: widget.customInfoWindowController,
                  height: 200,
                  width: 300,
                  offset: 35,
                ),
              ],
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
          heroTag: "locationbtn",
          child: const Icon(Icons.my_location),
          onPressed: () async {
            _goToCurrentLoc();

            // For testing notifications
            /*final prefs = await SharedPreferences.getInstance();
            final sound = prefs.getBool('sound') ?? true;
            final vibrate = prefs.getBool('vibrate') ?? true;
            Methods.decideNoti(sound, vibrate, 'Discounts nearby!', 'Discounts at: test', flutterLocalNotificationsPlugin);*/
          }
      ),
    );
  }
}
