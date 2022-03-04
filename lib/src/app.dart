import 'package:flutter/material.dart';

import 'connection/server_controller.dart';
import 'fake_backend/recipe.dart';
import 'fake_backend/user.dart';
import 'screens/add_recipe_page.dart';
import 'screens/details_page.dart';
import 'screens/home_page.dart';
import 'screens/login_page.dart';
import 'screens/my_favorites_page.dart';
import 'screens/mys_recipes_page.dart';
import 'screens/register_page.dart';

ServerController _serverController = ServerController();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      initialRoute: '/',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.cyan,
        accentColor: Colors.cyan[300],
        accentIconTheme: const IconThemeData(
          color: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
            textTheme: TextTheme(
                subtitle1: TextStyle(color: Colors.white, fontSize: 22)),
            iconTheme: IconThemeData(color: Colors.white)),
      ),
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (BuildContext context) {
          switch (settings.name) {
            case "/":
              return LoginPage(_serverController, context);
            case "/home":
              User loggedUser = settings.arguments as User;
              _serverController.loggedUser = loggedUser;
              return HomePage(_serverController);
            case "/register":
              User? loggedUser = settings.arguments as User?;
              return RegisterPage(
                _serverController,
                context,
                userToEdit: loggedUser,
              );
            case "/favorites":
              return MyFavoritesPage(
                _serverController,
              );
            case "/my_recipes":
              return MyRecipesPage(
                _serverController,
              );
            case "/add_recipe":
              return AddRecipePage(
                _serverController,
              );
            case "/edit_recipe":
              Recipe recipe = settings.arguments as Recipe;
              return AddRecipePage(
                _serverController,
                recipe: recipe,
              );
            case "/details":
              Recipe recipe = settings.arguments as Recipe;
              return DetailsPage(
                recipe: recipe,
                serverController: _serverController,
              );
            default:
              return LoginPage(_serverController, context);
          }
        });
      },
    );
  }
}
