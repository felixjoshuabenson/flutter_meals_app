import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naija_meals/models/meal.dart';
import 'package:naija_meals/providers/favourite_provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MealDetailScreen extends ConsumerStatefulWidget {
  const MealDetailScreen({super.key, required this.meal});

  final Meal meal;

  @override
  ConsumerState<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends ConsumerState<MealDetailScreen> {
  late YoutubePlayerController _youtubeController;

  @override
  void initState() {
    super.initState();
    final vidioId = YoutubePlayer.convertUrlToId(widget.meal.videoUrl);

    _youtubeController = YoutubePlayerController(
        initialVideoId: vidioId!,
        flags: YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ));
  }

  @override
  void dispose() {
    super.dispose();
    _youtubeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favouriteMeals = ref.watch(favouriteMealsProvider);
    final isFavorite = favouriteMeals.contains(widget.meal);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.meal.title,
        ),
        actions: [
          IconButton(
            onPressed: () {
              final wasAdded = ref
                  .read(favouriteMealsProvider.notifier)
                  .toggleMealFavouriteStatus(widget.meal);
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text(wasAdded ? 'Meal was added' : 'Meal was removed'),
                ),
              );
            },
            icon: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return RotationTransition(
                  turns: Tween(begin: 0.8, end: 1.0).animate(animation),
                  child: child,
                );
              },
              key: ValueKey(isFavorite),
              child: Icon(isFavorite ? Icons.star : Icons.star_border),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Hero(
            tag: widget.meal.id,
            child: Image.network(
              widget.meal.imageUrl,
              fit: BoxFit.cover,
              height: 300,
              width: double.infinity,
            ),
          ),
          const SizedBox(
            height: 14,
          ),
          Text(
            'Ingredients',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Theme.of(context).colorScheme.onSurface),
          ),
          const SizedBox(
            height: 14,
          ),
          for (final ingredients in widget.meal.ingredients)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                ingredients,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
            ),
          const SizedBox(
            height: 24,
          ),
          Text(
            'Steps',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Theme.of(context).colorScheme.onSurface),
          ),
          const SizedBox(
            height: 14,
          ),
          for (final steps in widget.meal.steps)
            Container(
              padding: EdgeInsets.all(12),
              child: Text(
                steps,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
            ),
          const SizedBox(
            height: 24,
          ),
          Text(
            'Video Demo',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Theme.of(context).colorScheme.onSurface),
          ),
          const SizedBox(
            height: 14,
          ),
          SizedBox(
            height: 300,
            width: double.infinity,
            child: YoutubePlayer(
              controller: _youtubeController,
              showVideoProgressIndicator: true,
            ),
          )
        ],
      )),
    );
  }
}
