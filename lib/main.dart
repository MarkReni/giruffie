import 'package:custom_info_window/custom_info_window.dart';
import 'package:delvr_demo_3/appbar.dart';
import 'package:delvr_demo_3/categorie_buttons.dart';
import 'package:delvr_demo_3/noti_filter.dart';
import 'package:delvr_demo_3/place_list.dart';
import 'package:delvr_demo_3/place_page.dart';
import 'package:delvr_demo_3/scrollable_place_list.dart';
import 'package:delvr_demo_3/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'methods.dart';
import 'objects.dart';
import 'map_view.dart';

final CustomInfoWindowController _customInfoWindowController = CustomInfoWindowController();

void main() {
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DELVR DEMO',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        sliderTheme: const SliderThemeData(
          showValueIndicator: ShowValueIndicator.always
        )
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(),
        '/settings': (context) => const SettingsPage(),
        PlacePage.routeName: (context) => const PlacePage()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {

  List<Place> allPlaces = [];
  List<Marker> allMarkers =  [];
  List<Marker> filteredMarkers = [];
  List<String> filter = [];
  String searchTerm = "";
  List<Place> filteredPlaces = [];
  List<String> categories = [];
  Set<int> selectedCategories = {};
  List<BitmapDescriptor> markerIcons = [];



  void initVars() async {
    allPlaces = await Methods.getDB();
    filteredPlaces = await Methods.filterPlaces(filter, allPlaces);
    markerIcons = Methods.addCustomIcons(filteredPlaces);
    categories = Methods.getCategories(allPlaces).toSet().union({"Suosikit"}).toList();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    Constants.searchController.addListener(() {
      setState(() {
        filter.remove(searchTerm);
        searchTerm = Constants.searchController.text;
        filter.add(searchTerm);
        initVars();
      });
    });

    Constants.buttonController.addListener(() {
      setState(() {
        selectedCategories = Constants.buttonController.selectedIndexes;
        List<String> names = [];
        for(int i in selectedCategories){
          names.add(categories[i]);
        }
        filter = {searchTerm}.union(names.toSet()).toList();
        initVars();
      });
    });

    initVars();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SearchAppBar(),

      drawer: Drawer(
        child: SafeArea(
            top: true,
            child: PlaceList(places: filteredPlaces, categories: categories, selected: selectedCategories,)
        )
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FilterPage(places: allPlaces, categories: categories))
          );
        },
        child: const Icon(Icons.filter_alt),
      ),

      body: Stack(
        children: [
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              double containerHeight = constraints.maxHeight * (1 - 0.2);
              return Positioned(
                top: kToolbarHeight,
                left: 0,
                right: 0,
                child: Container(
                  height: containerHeight,
                  child: MapView(
                    customInfoWindowController: _customInfoWindowController, 
                    places: filteredPlaces, 
                    icons: markerIcons, 
                    allPlaces: allPlaces,
                  ),
                ),
              );
            },
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CategoryButtons(categories: categories, selected: selectedCategories,)
          ),
          
          ScrollablePlaceList(allPlaces: allPlaces),
        ],
      ),
    );
  }
}
