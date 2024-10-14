import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naija_meals/providers/meals_provider.dart';

enum Filter { gluttenFree, lactoseFree, isVegan, isVegetarian, isStapleFood }

class FiltersNotifier extends StateNotifier<Map<Filter, bool>> {
  FiltersNotifier()
      : super({
          Filter.gluttenFree: false,
          Filter.lactoseFree: false,
          Filter.isStapleFood: false,
          Filter.isVegan: false,
          Filter.isVegetarian: false,
        });

  void setFilters(Map<Filter, bool> chosenFilters) {
    state = chosenFilters;
  }

  void setFilter(Filter filter, bool isActive) {
    state = {
      ...state,
      filter: isActive,
    };
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>(
  (ref) => FiltersNotifier(),
);

final filteredMealsProvider = Provider((ref) {
  final meals = ref.watch(mealsProvider);
  final activeFilters = ref.watch(filtersProvider);

  return meals.where((meal) {
    if (activeFilters[Filter.gluttenFree]! && !meal.isGluttenFree) {
      return false;
    }
    if (activeFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
      return false;
    }
    if (activeFilters[Filter.isVegan]! && !meal.isVegan) {
      return false;
    }
    if (activeFilters[Filter.isVegetarian]! && !meal.isVegetarian) {
      return false;
    }
    if (activeFilters[Filter.isStapleFood]! && !meal.isStapleFood) {
      return false;
    }
    return true;
  }).toList();
});
