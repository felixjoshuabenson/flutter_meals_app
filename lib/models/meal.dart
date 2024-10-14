enum Complexity {
  simple,
  challenging,
  hard,
}

enum Affordability {
  affordable,
  pricy,
  luxurious,
}

class Meal {
  const Meal(
      {required this.id,
      required this.categories,
      required this.title,
      required this.imageUrl,
      required this.ingredients,
      required this.steps,
      required this.duration,
      required this.affordability,
      required this.complexity,
      required this.isGluttenFree,
      required this.isLactoseFree,
      required this.isStapleFood,
      required this.isVegan,
      required this.isVegetarian,
      required this.videoUrl});

  final String id;
  final List<String> categories;
  final String title;
  final String imageUrl;
  final List<String> ingredients;
  final List<String> steps;
  final int duration;
  final String videoUrl;
  final Complexity complexity;
  final Affordability affordability;
  final bool isStapleFood;
  final bool isGluttenFree;
  final bool isLactoseFree;
  final bool isVegan;
  final bool isVegetarian;
}
