import 'package:flutter/material.dart';
import 'package:movies/screens/favorites.dart';
import 'package:movies/screens/movies.dart';
import 'package:movies/screens/profile.dart';
import 'package:movies/screens/search.dart';
import 'package:movies/screens/tv_shows.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = MoviesScreen();
    var activePageTitle = 'Movies';

    if (_selectedPageIndex == 1) {
      activePage = TvShowsScreen();
      activePageTitle = 'Tv Shows';
    } else if (_selectedPageIndex == 2) {
      activePage = FavoritesScreen();
      activePageTitle = 'Favorites';
    } else if (_selectedPageIndex == 3) {
      activePage = SearchScreen();
      activePageTitle = 'Search';
    } else if (_selectedPageIndex == 4) {
      activePage = ProfileScreen();
      activePageTitle = 'Profile';
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Movies'),
          BottomNavigationBarItem(icon: Icon(Icons.tv), label: 'Tv Shows'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Profile'),
        ],
      ),
    );
  }
}
