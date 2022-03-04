import 'package:flutter/material.dart';

import '../components/recipe_widget.dart';
import '../connection/server_controller.dart';
import '../fake_backend/recipe.dart';

class MyRecipesPage extends StatefulWidget {
  final ServerController serverController;

  const MyRecipesPage(this.serverController, {Key? key}) : super(key: key);

  @override
  _MyRecipesPageState createState() => _MyRecipesPageState();
}

class _MyRecipesPageState extends State<MyRecipesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis recetas"),
      ),
      body: FutureBuilder<List<Recipe>>(
        future: widget.serverController.getUserRecipesList(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List<Recipe> list = snapshot.data;

            if (list.isEmpty) {
              return SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.info,
                        size: 120,
                        color: Colors.grey[300],
                      ),
                      const Text(
                        "No se encontró ninguna receta en su biblioteca, puede agregar una receta desde la pantalla principal",
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              );
            }

            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                Recipe recipe = list[index];

                return RecipeWidget(
                  recipe: recipe,
                  serverController: widget.serverController,
                  onChange: () {
                    setState(() {});
                  },
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
