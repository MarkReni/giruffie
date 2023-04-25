import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'objects.dart';

class FilterPage extends StatefulWidget {
  const FilterPage(
      {Key? key,
      required this.places,
      required this.categories,
      })
      : super(key: key);

  final List<Place> places;
  final List<String> categories;

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {

  List<String> favouriteCategories = [];
  bool settingEnabled = false;

  void loadSelected() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favouriteCategories = (prefs.getStringList('favouriteCategories') ?? []);
      settingEnabled = (prefs.getBool('onlyFavourites') ?? false);
    });
  }

  void setSelected(String category) async {
    final prefs = await SharedPreferences.getInstance();
    favouriteCategories = (prefs.getStringList('favouriteCategories') ?? []);
    setState(() {
      if(favouriteCategories.contains(category)){
        favouriteCategories.remove(category);
      }else{
        favouriteCategories.add(category);
      }
      prefs.setStringList('favouriteCategories', favouriteCategories);
    });
  }

  @override
  void initState() {
    loadSelected();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications Filter'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: settingEnabled ? const Text("Only receive notifications from these categories and favourites") : const Text("Enable notification filtering in settings for these selections to take effect")
          ),
          for (var category in widget.categories)
            CheckboxListTile(
              title: Text(category),
              value: favouriteCategories.contains(category),
              onChanged: (newValue) {
                setState(() {
                  setSelected(category);
                });
              },
            ),
        ],
      ),
    );
  }
}
