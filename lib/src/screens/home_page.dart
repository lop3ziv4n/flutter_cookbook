import 'package:flutter/material.dart';

import '../components/my_drawer.dart';
import '../components/recipe_widget.dart';
import '../connection/server_controller.dart';
import '../fake_backend/recipe.dart';

class HomePage extends StatefulWidget {
  final ServerController serverController;

  const HomePage(this.serverController, {Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cookbook"),
      ),
      drawer: MyDrawer(
        serverController: widget.serverController,
      ),
      body: FutureBuilder<List<Recipe>>(
        future: widget.serverController.getRecipesList(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final list = snapshot.data;
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
        ),
        onPressed: () {
          Navigator.of(context).pushNamed("/add_recipe");
        },
      ),
    );
  }
}
