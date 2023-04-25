import 'package:delvr_demo_3/buttons.dart';
import 'package:flutter/material.dart';

import 'objects.dart';

class PlacePage extends StatefulWidget{
  const PlacePage({Key? key}) : super(key:key);

  static const routeName = '/placepage';

  @override
  State<PlacePage> createState() => _PlacePageState();
}

class _PlacePageState extends State<PlacePage> {

  @override

  Widget build(BuildContext context){

    final args = ModalRoute.of(context)!.settings.arguments as Place;

    return Scaffold(
      appBar: AppBar(
        title: Text(args.title),
      ),
      body: Center(
        child: Column(
          children: [
            ListTile(
              title: Text("Kategoria: ${args.category}"),
              leading: const Icon(Icons.category),
            ),
            ListTile(
              title: Text(args.description),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: args.getDiscounts().length,
                  itemBuilder: (BuildContext context, index){
                    return ListTile(
                      dense: true,
                      visualDensity: VisualDensity.compact,
                      leading: const Icon(Icons.discount),
                      title: Text(args.getDiscounts()[index]),
                    );
                  }
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FavoriteButton(place: args),
            BlacklistButton(place: args)
          ],
        ),
      ),
    );
  }
}