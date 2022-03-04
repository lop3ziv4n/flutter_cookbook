import 'package:flutter/material.dart';

import '../fake_backend/recipe.dart';

class TabIngredientsWidget extends StatelessWidget {
  final Recipe recipe;

  const TabIngredientsWidget({required this.recipe, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
      ),
      children: <Widget>[
        Text(
          recipe.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          recipe.description,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          "Ingredientes",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Column(
          children: List.generate(
            recipe.ingredients.length,
            (int index) {
              final ingredient = recipe.ingredients[index];
              return ListTile(
                leading: Container(
                  height: 15,
                  width: 15,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                title: Text(ingredient),
              );
            },
          ),
        ),
      ],
    );
  }
}
