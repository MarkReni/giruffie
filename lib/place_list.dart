import 'package:delvr_demo_3/categorie_buttons.dart';
import 'package:delvr_demo_3/objects.dart';
import 'package:delvr_demo_3/place_page.dart';
import 'package:flutter/material.dart';

class PlaceList extends StatefulWidget{
  const PlaceList({Key? key, required this.places, required this.categories, required this.selected}) : super(key:key);

  final List<String> categories;

  final Set<int> selected;

  final List<Place> places;

  @override
  State<PlaceList> createState() => _PlaceListState();
}

class _PlaceListState extends State<PlaceList> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              hintText: "Search"
            ),
            controller: Constants.searchController,
            onChanged: (String value){
              Constants.searchTerm = value;
              setState(() {});
            },
          ),
          CategoryButtons(
              categories: widget.categories,
              selected: widget.selected
          ),
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: widget.places.length,
                itemBuilder: (context, index){
                  return Card(
                    key: UniqueKey(),
                    child: ListTile(
                      title: Text(widget.places[index].title),
                      onTap: (){
                        Navigator.pushNamed(
                            context,
                            PlacePage.routeName,
                            arguments: widget.places[index]
                        );
                      },
                    ),
                  );
                }
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        heroTag: "settingsbtn",
        onPressed: (){
          Navigator.pushNamed(context, '/settings');
        },
        child: const Icon(Icons.settings),
      ),
    );
  }
}