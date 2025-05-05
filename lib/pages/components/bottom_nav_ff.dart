import 'package:flutter/material.dart';

class BottomNavFF extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavFF({Key? key, required this.currentIndex, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
return Container(
  decoration: BoxDecoration(
    color: Color.fromRGBO(240, 248, 255, 1.0),
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(50),
      topRight: Radius.circular(50),
      bottomLeft: Radius.circular(50),
      bottomRight: Radius.circular(50),
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: const Offset(0, -2),
      ),
    ],
  ),
  child: BottomNavigationBar(
    currentIndex: currentIndex,
    onTap: onTap,
    backgroundColor: Colors.transparent,
    type: BottomNavigationBarType.fixed,
    elevation: 0,
    selectedItemColor: Colors.red[900],
    unselectedItemColor: Colors.black38,
    selectedLabelStyle: const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 13,
    ),
    unselectedLabelStyle: const TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 12,
    ),
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined, size: 30),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.insert_drive_file_outlined, size: 30),
        label: 'Reports',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.settings_rounded, size: 30),
        label: 'Settings',
      ),
    ],
  ),
);





  }
}
