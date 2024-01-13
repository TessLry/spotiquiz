import 'package:flutter/material.dart';
import 'package:spotiquiz/ui/screens/home.dart';
import 'package:spotiquiz/ui/screens/score_page.dart';

class NavigationTabBar extends StatefulWidget {
  const NavigationTabBar({super.key});

  @override
  State<NavigationTabBar> createState() => _NavigationTabBarState();
}

class _NavigationTabBarState extends State<NavigationTabBar> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[Home(), ScorePage()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _selectedIndex == 0
                ? const Icon(Icons.home)
                : const Icon(Icons.home_outlined),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 1
                ? const Icon(Icons.emoji_events)
                : const Icon(Icons.emoji_events_outlined),
            label: 'Score',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white38,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        backgroundColor: Colors.white10,
      ),
    );
  }
}
