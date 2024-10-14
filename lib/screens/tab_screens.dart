import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naija_meals/providers/favourite_provider.dart';
import 'package:naija_meals/providers/filters_provider.dart';
import 'package:naija_meals/screens/category_screens.dart';
import 'package:naija_meals/screens/filters_screen.dart';
import 'package:naija_meals/screens/meals_screen.dart';
import 'package:naija_meals/widgets/main_drawer.dart';

const kInitialFilters = {
  Filter.gluttenFree,
  Filter.isStapleFood,
  Filter.isVegan,
  Filter.isVegetarian,
  Filter.lactoseFree,
};

class TabScreens extends ConsumerStatefulWidget {
  const TabScreens({super.key});

  @override
  ConsumerState<TabScreens> createState() => _TabScreensState();
}

class _TabScreensState extends ConsumerState<TabScreens> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'filters') {
      await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => FiltersScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = ref.watch(filteredMealsProvider);
    Widget activePage = CategoryScreens(availableMeals: availableMeals);

    var activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      final favouriteMeals = ref.watch(favouriteMealsProvider);
      print('vvv $favouriteMeals');
      activePage = MealsScreen(meals: favouriteMeals, title: '',);
      activePageTitle = 'Your Favourites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(onSelectScreen: _setScreen),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
          onTap: _selectPage,
          currentIndex: _selectedPageIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.set_meal), label: 'Categories'),
            BottomNavigationBarItem(
                icon: Icon(Icons.star), label: 'Favourites'),
          ]),
    );
  }
}
