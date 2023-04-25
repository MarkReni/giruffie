import 'package:delvr_demo_3/place_list_tile.dart';
import 'package:flutter/material.dart';

import 'objects.dart';

class ScrollablePlaceList extends StatefulWidget{
  const ScrollablePlaceList({Key? key, required this.allPlaces }) : super(key:key);

  final List<Place> allPlaces;

  @override
  State<ScrollablePlaceList> createState() => _ScrollablePlaceListState();
}

class _ScrollablePlaceListState extends State<ScrollablePlaceList> {  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.2,
      minChildSize: 0.2,
      snap: true,
      snapSizes: const [0.2, 1],
      builder: (context, scrollController) {
        return Container(
          color: const Color(0xFFD3E8FD),
          child: ListView.builder(
            controller: scrollController,
            itemCount: widget.allPlaces.length + 1,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Container(
                  color: const Color(0xFF4D8ADB),
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: const Center(
                    child: Text(
                        "Offers in the area:",
                      style: TextStyle(
                        color: Colors.white,
                      )
                    )
                  ),
                );
              } else {
                return PlaceListTile(place: widget.allPlaces[index - 1]);
              }
            },
          ),
        );
      },
    );
  }
}