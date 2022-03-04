import '../fake_backend/data_init.dart' as data_init;
import '../fake_backend/data_provider.dart' as server;
import '../fake_backend/recipe.dart';
import '../fake_backend/user.dart';

class ServerController {
  User? loggedUser;

  void init() {
    data_init.generateData();
  }

  Future<User?> login(String userName, String password) async {
    return await server.backendLogin(userName, password);
  }

  Future<bool> addUser(User nUser) async {
    return await server.addUser(nUser);
  }

  Future<List<Recipe>> getRecipesList() async {
    return await server.getRecipes();
  }

  Future<bool> getIsFavorite(Recipe recipeToCheck) async {
    return await server.isFavorite(recipeToCheck);
  }

  Future<Recipe> addFavorite(Recipe nFavorite) async {
    return await server.addFavorite(nFavorite);
  }

  Future<bool> deleteFavorite(Recipe favoriteRecipe) async {
    return await server.deleteFavorite(favoriteRecipe);
  }

  Future<bool> updateUser(User user) async {
    loggedUser = user;
    return await server.updateUser(user);
  }

  Future<List<Recipe>> getFavoritesList() async {
    return await server.getFavorites();
  }

  Future<List<Recipe>> getUserRecipesList() async {
    return await server.getUserRecipes(loggedUser!);
  }

  Future<Recipe> addRecipe(Recipe nRecipe) async {
    return await server.addRecipe(nRecipe);
  }

  Future<bool> updateRecipe(Recipe recipe) async {
    return await server.updateRecipe(recipe);
  }
}
