import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';

import 'objects.dart';

class CategoryButtons extends StatefulWidget {
  const CategoryButtons({Key? key, required this.categories, required this.selected}) : super(key:key);

  final List<String> categories;

  final Set<int> selected;

  @override
  State<CategoryButtons> createState() => _CategoryButtonsState();
}

class _CategoryButtonsState extends State<CategoryButtons> {

  Icon getIcon(int i){
    switch(widget.categories[i]) {
      case "Ravintola" : {return const Icon(Icons.local_restaurant);}
      case "Ruokakauppa" : {return const Icon(Icons.local_grocery_store);}
      case "Vaatteet" : {return const Icon(DelvrIcons.tshirt);}
      case "Testi" : {return const Icon(Icons.build);}
      case "Suosikit" : {return const Icon(Icons.favorite);}
      case "Kahvila" : {return const Icon(Icons.coffee);}
      default: {return const Icon(Icons.question_mark);}
    }
  }

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return SizedBox(
      height: 45,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          GroupButton(
            options: const GroupButtonOptions(
            groupingType: GroupingType.row,
                direction: Axis.horizontal,
                alignment: Alignment.bottomLeft
            ),
            controller: Constants.buttonController,
            isRadio: false,
            buttons: widget.categories,

            buttonIndexedBuilder: (selected, index, context){
              return GestureDetector(
                onTap: () => setState(() {
                  if(!selected){
                    Constants.buttonController.selectIndex(index);
                    return;
                  }else{
                    Constants.buttonController.unselectIndex(index);
                  }
                }),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Chip(
                    backgroundColor: selected ? Colors.blue : Colors.grey,
                    label: Text(widget.categories[index])
                ),
                )
              );
            },
          )
        ],
      ),
    );
  }
}