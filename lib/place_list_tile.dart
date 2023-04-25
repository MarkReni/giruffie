import 'package:delvr_demo_3/place_page.dart';
import 'package:flutter/material.dart';

import 'objects.dart';

class PlaceListTile extends StatelessWidget {
  final Place place;

  const PlaceListTile({Key? key, required this.place}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    List<String> discounts = place.getDiscounts();

    return Padding(
      padding: const EdgeInsets.all(3),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFA46B28),
          borderRadius: BorderRadius.circular(10)
        ),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
                context,
                PlacePage.routeName,
                arguments: place,
            );
          },
          child: Column(
            children: [
              ListTile(
                title: Text(place.title),
                tileColor: Colors.white,
              ),
              Padding(
                padding: const EdgeInsets.all(0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF3C88C),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)
                    )
                  ),

                  child: Column(
                    children: <Widget>[
                      for (var i = 0; i < discounts.length; i++) 
                        ListTile(
                          dense: true,
                          leading: const Icon(Icons.discount),
                          title: Text(discounts[i]),
                        )
                    ]
                  ),
                ),
              )
            ]
          )
        )
      )
    );
  }
}