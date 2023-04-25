import 'package:flutter/material.dart';

import 'objects.dart';

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget{
  const SearchAppBar({Key? key}) : super(key:key);

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

class _SearchAppBarState extends State<SearchAppBar>{

  Widget appBarTitle = const Text("DELVR");
  Icon appBarAction = const Icon(Icons.search);

  @override
  Widget build(BuildContext context){
    return AppBar(
      title: appBarTitle,
      actions: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: appBarAction,
              onPressed: (){
                setState(() {
                  if(appBarAction.icon == Icons.search){
                    appBarAction = const Icon(Icons.close);
                    appBarTitle = TextFormField(
                      controller: Constants.searchController,
                      onChanged: (String value){
                        Constants.searchTerm = value;
                        setState(() {});
                      },
                    );
                  }else{
                    appBarAction = const Icon(Icons.search);
                    appBarTitle = const Text("Girufie");
                    Constants.searchController.text = "";
                    Constants.searchTerm = "";
                    setState(() {});
                  }
                });
              },
            )
          ],
        )
      ],
      backgroundColor: const Color(0xFF4D8ADB),
    );
  }
}
