import 'package:flutter/material.dart';


class BottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNav({Key? key, required this.currentIndex, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white, // Change this to any color you want
      selectedItemColor: Colors.red[900], // Color of selected item
      unselectedItemColor: Colors.black38, // Color of unselected items
      selectedLabelStyle: TextStyle(),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled, size: 40),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.insert_drive_file_outlined, size: 40),
          label: 'Fire Reports',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.fire_truck, size: 40),
          label: 'Fire Stations',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, size: 40),
          label: 'Profile',
        ),
      ],
    );
  }
}
