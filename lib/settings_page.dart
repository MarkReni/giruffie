import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'map_view.dart';
import 'methods.dart';

class SettingsPage extends StatefulWidget{
  const SettingsPage({Key? key}) : super(key:key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  bool soundOn = true;
  bool vibrateOn = true;
  double distance = 50.0;
  bool onlyFavourites = false;

  @override
  void initState(){
    super.initState();
    loadValues();
  }

  // Load current values for selected settings. If not set yet, default to true, true, 50 m and false
  void loadValues() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      soundOn = (prefs.getBool('sound') ?? true);
      vibrateOn = (prefs.getBool('vibrate') ?? true);
      distance = (prefs.getDouble('distance') ?? 50.0);
      onlyFavourites = (prefs.getBool('onlyFavourites') ?? false);
    });
  }

  // Set notification sound preference. If not set yet, changes from the default true to false
  void setSound() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      soundOn = (prefs.getBool('sound') ?? true) ? false : true;
      prefs.setBool('sound', soundOn);
    });
  }

  // Set notification vibrate preference. If not set yet, changes from the default true to false
  void setVibrate() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      vibrateOn = (prefs.getBool('vibrate') ?? true) ? false : true;
      prefs.setBool('vibrate', vibrateOn);
    });
  }

  // Set notification distance preference.
  void setDistance(double newDist) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      distance = newDist;
      prefs.setDouble('distance', distance);
    });
  }

  void setOnlyFavourites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      onlyFavourites = (prefs.getBool('onlyFavourites') ?? false) ? false : true;
      prefs.setBool('onlyFavourites', onlyFavourites);
    });
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Center(
        child: Column(
          children: [
            OutlinedButton(
                onPressed: (){
                  setSound();
                },
                child: soundOn ? const Text("Sound enabled") : const Text("Sound disabled")
            ),
            OutlinedButton(
                onPressed: (){
                  setVibrate();
                },
                child: vibrateOn ? const Text("Vibrate enabled") : const Text("Vibrate disabled")
            ),
            const Text("Notification distance"),
            Slider(
                value: distance,
                min: 0.0,
                max: 100.0,
                divisions: 10,
                label: distance.toString(),
                onChanged: (value) {
                  setDistance(value);
                }
            ),
            OutlinedButton(
                onPressed: (){
                  setOnlyFavourites();
                },
                child: onlyFavourites
                    ? const Text("Receiving notifications only from favourite places or categories")
                    : const Text("Receiving notifications from all places")
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "testNotifications",
        child: const Icon(Icons.notifications_active),
          onPressed: () async {
            // For testing notifications
            final prefs = await SharedPreferences.getInstance();
            final sound = prefs.getBool('sound') ?? true;
            final vibrate = prefs.getBool('vibrate') ?? true;
            Methods.decideNoti(sound, vibrate, 'Discounts nearby!', 'Discounts at: test', flutterLocalNotificationsPlugin);
          }
      ),
    );
  }
}