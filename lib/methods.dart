import 'package:delvr_demo_3/place_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'buttons.dart';
import 'notifications.dart';
import 'objects.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:custom_info_window/custom_info_window.dart';

class Methods {
  static Future<List<Place>> getDB() async {
    var dbDir = await getDatabasesPath();
    var dbPath = join(dbDir, "app.db");

    List<Place> places = [];

    await deleteDatabase(dbPath);

    ByteData data = await rootBundle.load("lib/assets/places.db");
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(dbPath).writeAsBytes(bytes);
    var db = await openDatabase(dbPath);

    final List<Map<String, dynamic>> maps = await db.query('places');

    List.generate(maps.length, (i) {
      places.add(Place(
          id: maps[i]['id'],
          title: maps[i]['title'],
          lat: maps[i]['lat'],
          lng: maps[i]['lng'],
          description: maps[i]['description'],
          category: maps[i]['category'],
          tags: maps[i]['tags'],
          discounts: maps[i]['discounts']
      ));
    });
    // After places has been populated call return places
    return places;
  }

  static List<BitmapDescriptor> addCustomIcons(List<Place> places){
    var markerIcons = List<BitmapDescriptor>.filled(places.length, BitmapDescriptor.defaultMarker);
    for(int i = 0; i < places.length; i++){
      BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(),
          "lib/assets/images/${places[i].category}.png"
      ).then((icon) {
          markerIcons[i] = icon;
      });
    }
    return markerIcons;
  }

  static Future<String> getMapStyle() async {
    String mapStyle = await rootBundle.loadString('lib/assets/map_style.txt');
    return mapStyle;
  }


  static List<Marker> loadData(List<Place> places, CustomInfoWindowController customInfoWindowController, BuildContext context, List<BitmapDescriptor> markerIcons) {
    List<Marker> markers = [];

    for(int i = 0; i < places.length; i++){
      markers.add(
          Marker(
              icon: markerIcons[i],
              markerId: MarkerId(places[i].id.toString()),
              position: places[i].getLoc(),
              onTap: (){
                customInfoWindowController.addInfoWindow!(
                    Container(
                      height: 300,
                      width: 200,
                      decoration: BoxDecoration(
                          color: const Color(0xFFF3C88C),
                          borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                          style: BorderStyle.solid
                        )
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Opacity( // ONLY HERE TO ALIGN TEXT
                                opacity: 0,
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.close),
                                    alignment: Alignment.centerRight,
                                  )
                              ),
                              SizedBox(
                                width: 150,
                                child: Text(
                                  places[i].title,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    customInfoWindowController.hideInfoWindow!();
                                  },
                                  icon: const Icon(Icons.close),
                                  alignment: Alignment.centerRight,
                              )

                            ]
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton(
                                  onPressed: (){
                                    Navigator.pushNamed(
                                        context,
                                        PlacePage.routeName,
                                        arguments: places[i]
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.grey,
                                  ),
                                  child: const Text("Lisää")
                              ),
                              FavoriteButton(place: places[i]),
                              BlacklistButton(place: places[i]),
                            ],
                          ),
                          Expanded(
                            child: ListView.builder(
                                itemCount: places[i].getDiscounts().length,
                                itemBuilder: (BuildContext context, index){
                                  return ListTile(
                                    dense: true,
                                    visualDensity: VisualDensity.compact,
                                    leading: const Icon(Icons.discount),
                                    title: Text(places[i].getDiscounts()[index]),
                                  );
                                }
                            ),
                          ),
                        ],
                      ),
                    ),
                    places[i].getLoc()
                );
              }
          )
      );

    }
    return markers;
  }

  static bool filterCases(Place e, List<String> filter) {
    var bool = false;
    for (String string in filter) {
      if (e.category.toLowerCase().contains(string.toLowerCase()) ||
          e.title.toLowerCase().contains(string.toLowerCase()) ||
          e.description.toLowerCase().contains(string.toLowerCase()) ||
          e.tags.toLowerCase().contains(string.toLowerCase())) {
        bool = true;
      }
    }

    return bool;
  }

  // Filter function for filtering markers by a list of categories
  static List<Marker> filterMarkers(
      List<String> filter, List<Marker> markers, List<Place> places) {

    filter.removeWhere((element) => ["", null].contains(element));

    var filteredPlaces =
        places.where((e) => filterCases(e, filter)).map((p) => p.id.toString());
    return markers
        .where((m) => filteredPlaces.contains(m.markerId.value))
        .toList();
  }

  static Future<List<Place>> filterPlaces(List<String> filter, List<Place> places) async {
    filter.removeWhere((element) => ["", null].contains(element));

    var filteredPlaces = filter.isEmpty ? places : places.where((e) => filterCases(e, filter)).toList();
    if(filter.contains("Suosikit")){
      for(Place place in places){
        if(await place.getFavourite() && !filteredPlaces.contains(place)){
          filteredPlaces.add(place);
        }
      }
    }

    return filteredPlaces;
  }

  static List<String> getCategories(List<Place> places) {
    var res = places.map((e) => e.category).toSet().toList();
    return res;
  }

  static void decideNoti(bool sound, bool vibrate, String title, String body, FlutterLocalNotificationsPlugin fln) async {
    if(sound && vibrate){
      SoundNoti.showBigTextNotification(title: title, body: body, fln: fln);
    }else if(!sound && vibrate){
      VibrateNoti.showBigTextNotification(title: title, body: body, fln: fln);
    }else if(!sound && !vibrate){
      SilentNoti.showBigTextNotification(title: title, body: body, fln: fln);
    }else{
      OnlySoundNoti.showBigTextNotification(title: title, body: body, fln: fln);
    }
  }

  static Future<bool> notifyForPlace(Place place) async {
    final prefs = await SharedPreferences.getInstance();
    final onlyFavourites = prefs.getBool('onlyFavourites') ?? false;
    final favouritedCategories = prefs.getStringList('favouriteCategories') ?? [];
    return ( !await place.getBlacklisted() ) && ( !onlyFavourites || ( await place.getFavourite() || favouritedCategories.contains(place.category) ) );
    // place is not blacklisted and it is in notify categories or in favorites if onlyFavourites is selected.
  }


}