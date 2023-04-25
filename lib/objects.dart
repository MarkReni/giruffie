import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Place {
  final int id;
  final String title;
  final double lat;
  final double lng;
  final String description;
  final String category;
  final String tags;
  final String discounts;

  bool favourite = false;
  bool blacklisted = false;

  Future<bool> getFavourite() async {
    final prefs = await SharedPreferences.getInstance();
    favourite = (prefs.getBool('$id-favourite') ?? favourite);
    return favourite;
  }

  Future<bool> getBlacklisted() async {
    final prefs = await SharedPreferences.getInstance();
    blacklisted = (prefs.getBool('$id-blacklisted') ?? blacklisted);
    return blacklisted;
  }

  Future<bool> setFavourite() async {
    final prefs = await SharedPreferences.getInstance();
    favourite = (prefs.getBool('$id-favourite') ?? false) ? false : true;
    prefs.setBool('$id-favourite', favourite);
    return favourite;
  }

  Future<bool> setBlacklisted() async {
    final prefs = await SharedPreferences.getInstance();
    blacklisted = (prefs.getBool('$id-blacklisted') ?? false) ? false : true;
    prefs.setBool('$id-blacklisted', blacklisted);
    return blacklisted;
  }

  Place({required this.id, required this.title, required this.lat, required this.lng, required this.description, required this.category, required this.tags, required this.discounts});

  LatLng getLoc(){
    return LatLng(lat, lng);
  }

  List<String> getDiscounts(){
    return discounts.split('|').map((e) => e.trim()).toList();
  }

  @override
  String toString(){
    return 'Place{id: $id, title: $title, lat: $lat, lng: $lng, desc: $description, category: $category, pincolor: $tags}';
  }
}

class Constants {

  static String searchTerm = "";

  static TextEditingController searchController = TextEditingController();
  static GroupButtonController buttonController = GroupButtonController();

}


class CheckBoxTile extends StatelessWidget {
  const CheckBoxTile({
    Key? key,
    required this.selected,
    required this.onTap,
    required this.title,
  }) : super(key: key);

  final Icon title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: selected
            ? OutlinedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white)
            : OutlinedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.blue),
        onPressed: (){
          onTap();
        },
        child: title
    );
  }
}

class DelvrIcons {
  DelvrIcons._();

  static const _kFontFam = 'DelvrIcons';
  static const String? _kFontPkg = null;

  static const IconData tshirt = IconData(0xf553, fontFamily: _kFontFam, fontPackage: _kFontPkg);
}
