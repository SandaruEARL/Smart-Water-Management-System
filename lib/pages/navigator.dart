
import 'package:aqua/pages/new_usage.dart';
import 'package:aqua/pages/profile.dart';
import 'package:aqua/pages/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'new_home.dart';




class MyNavigationBar extends StatefulWidget {
  const MyNavigationBar({super.key});


  @override
  State<MyNavigationBar> createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {



  int currentPageIndex = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Container( decoration:  BoxDecoration(borderRadius:BorderRadius.circular(0),gradient: LinearGradient(colors: [Colors.blue,Colors.blueGrey])),

          child: GNav(

            color: Colors.blue[200],
            activeColor: Colors.white,
            tabBackgroundColor: Colors.blue.shade200,
            padding: const EdgeInsets.all(20),
            duration: const Duration(milliseconds: 400),
            tabBorderRadius: 40,
            tabMargin: const EdgeInsets.all(10),
            hoverColor: Colors.blueGrey,
            rippleColor: Colors.blue,
            gap: 1,

            tabs: const [


              GButton(icon: Icons.dashboard,text: "Dash",),
              GButton(icon: Icons.analytics,text: "Usage"),
              GButton(icon: Icons.settings,text: "Settings"),
              GButton(icon: Icons.person,text: "Profile"),


            ],

            onTabChange: (index){ setState(() {
              currentPageIndex = index;
            });},

          ),
        ),
      ),
      body:  const [
        HomePage(),
        UsageOld(),
        SettingsPage(),
        ProfilePage(),

      ][currentPageIndex],
    );
  }
}