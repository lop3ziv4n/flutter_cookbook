import 'package:flutter/material.dart';

import '../connection/server_controller.dart';
import '../fake_backend/recipe.dart';

class RecipeWidget extends StatelessWidget {
  final Recipe recipe;
  final ServerController serverController;
  final VoidCallback onChange;

  const RecipeWidget(
      {required this.recipe,
      required this.serverController,
      required this.onChange,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
      child: GestureDetector(
        onTap: () => _showDetails(context),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Card(
            child: Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                image: recipe.photo != null
                    ? DecorationImage(
                        image: FileImage(
                          recipe.photo!,
                        ),
                        fit: BoxFit.cover,
                      )
                    : DecorationImage(
                        image: AssetImage(
                          recipe.assets!,
                        ),
                        fit: BoxFit.cover,
                      ),
              ),
              alignment: Alignment.bottomLeft,
              child: Container(
                color: Colors.black.withOpacity(0.35),
                child: ListTile(
                  title: Text(
                    recipe.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    recipe.user.nickname,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  trailing: _getFavoriteWidget(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getFavoriteWidget() {
    return FutureBuilder<bool>(
      future: serverController.getIsFavorite(recipe),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final isFavorite = snapshot.data;
          if (isFavorite!) {
            return IconButton(
              icon: const Icon(
                Icons.favorite,
              ),
              color: Colors.red,
              onPressed: () async {
                await serverController.deleteFavorite(recipe);
                onChange();
              },
              iconSize: 32,
            );
          } else {
            return IconButton(
              icon: const Icon(
                Icons.favorite_border,
              ),
              color: Colors.white,
              onPressed: () async {
                await serverController.addFavorite(recipe);
                onChange();
              },
              iconSize: 32,
            );
          }
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  _showDetails(BuildContext context) {
    Navigator.pushNamed(context, "/details", arguments: recipe);
  }
}
