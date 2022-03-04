import 'package:flutter/material.dart';

import '../components/tab_ingredients_widget.dart';
import '../components/tab_preparation.dart';
import '../connection/server_controller.dart';
import '../fake_backend/recipe.dart';

class DetailsPage extends StatefulWidget {
  Recipe recipe;
  final ServerController serverController;

  DetailsPage({required this.recipe, required this.serverController, key})
      : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool? favorite;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                title: Text(widget.recipe.name),
                expandedHeight: 320,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    image: widget.recipe.photo != null
                        ? DecorationImage(
                            image: FileImage(
                              widget.recipe.photo!,
                            ),
                            fit: BoxFit.cover,
                          )
                        : DecorationImage(
                            image: AssetImage(
                              widget.recipe.assets!,
                            ),
                            fit: BoxFit.cover,
                          ),
                  ),
                  child: Container(
                    color: Colors.black.withOpacity(.5),
                  ),
                ),
                pinned: true,
                bottom: const TabBar(
                  labelColor: Colors.white,
                  indicatorWeight: 4,
                  tabs: <Widget>[
                    Tab(
                        child: Text(
                      'Ingredientes',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    )),
                    Tab(
                        child: Text(
                      'Preparación',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    )),
                  ],
                ),
                actions: <Widget>[
                  if (widget.recipe.user.id ==
                      widget.serverController.loggedUser!.id)
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                      ),
                      onPressed: () async {
                        final nRecipe = await Navigator.of(context).pushNamed(
                            "/edit_recipe",
                            arguments: widget.recipe);
                        setState(() {
                          widget.recipe = nRecipe as Recipe;
                        });
                      },
                    ),
                  getFavoriteWidget(),
                  IconButton(
                    icon: const Icon(
                      Icons.help_outline,
                    ),
                    onPressed: () {
                      _showAboutIt(context);
                    },
                  ),
                ],
              )
            ];
          },
          body: TabBarView(
            children: <Widget>[
              TabIngredientsWidget(
                recipe: widget.recipe,
              ),
              TapPreparationWidget(
                recipe: widget.recipe,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getFavoriteWidget() {
    if (favorite != null) {
      if (favorite!) {
        return IconButton(
          icon: const Icon(
            Icons.favorite,
          ),
          color: Colors.red,
          onPressed: () async {
            await widget.serverController.deleteFavorite(widget.recipe);
            setState(() {
              favorite = false;
            });
          },
        );
      } else {
        return IconButton(
          icon: const Icon(
            Icons.favorite_border,
          ),
          color: Colors.white,
          onPressed: () async {
            await widget.serverController.addFavorite(widget.recipe);
            setState(() {
              favorite = true;
            });
          },
        );
      }
    } else {
      return Container(
          margin: const EdgeInsets.all(15),
          width: 30,
          child: const CircularProgressIndicator());
    }
  }

  @override
  void initState() {
    super.initState();
    loadState();
  }

  void loadState() async {
    final state = await widget.serverController.getIsFavorite(widget.recipe);
    setState(() {
      favorite = state;
    });
  }

  void _showAboutIt(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Acerca de la receta"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Expanded(
                    child: Text(
                      "Nombre: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(widget.recipe.name),
                ],
              ),
              const Divider(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Expanded(
                      child: Text(
                    "Usuario: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  Text(widget.recipe.user.nickname),
                ],
              ),
              const Divider(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Expanded(
                    child: Text(
                      "Fecha de publicación: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                      "${widget.recipe.date.day}/${widget.recipe.date.month}/${widget.recipe.date.year}"),
                ],
              )
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cerrar"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}
