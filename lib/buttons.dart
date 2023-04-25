import 'package:delvr_demo_3/objects.dart';
import 'package:flutter/material.dart';

class FavoriteButton extends StatefulWidget {
  final Place place;

  const FavoriteButton({Key? key, required this.place}) : super(key: key);

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  
  bool favourite = false;
  void loadValue() async {
    var res = await widget.place.getFavourite();
    setState(() {
      favourite = res;
    });
  }

  void setValue() async {
    var res = await widget.place.setFavourite();
    setState(() {
      favourite = res;
    });
  }
  
  @override
  void initState() {
    loadValue();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.favorite,
        color: favourite ? Colors.red : Colors.grey,
      ),
      onPressed: (){
        setValue();
      },
    );
  }
}


class BlacklistButton extends StatefulWidget {
  final Place place;

  const BlacklistButton({Key? key, required this.place}) : super(key: key);

  @override
  State<BlacklistButton> createState() => _BlacklistButtonState();
}

class _BlacklistButtonState extends State<BlacklistButton> {
  bool blacklisted = false;
  void loadValue() async {
    var res = await widget.place.getBlacklisted();
    setState(() {
      blacklisted = res;
    });
  }

  void setValue() async {
    var res = await widget.place.setBlacklisted();
    setState(() {
      blacklisted = res;
    });
  }

  @override
  void initState() {
    loadValue();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.block,
        color: blacklisted ? Colors.lightBlue : Colors.grey,
      ),
      onPressed: (){
        setValue();
      },
    );

  }
}
