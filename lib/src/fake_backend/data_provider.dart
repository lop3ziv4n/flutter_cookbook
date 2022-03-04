import 'data_init.dart';
import 'recipe.dart';
import 'user.dart';

Future<List<User>> getUsers() async {
  await Future.delayed(const Duration(seconds: 3));
  return users;
}

Future<List<Recipe>> getRecipes() async {
  await Future.delayed(const Duration(seconds: 3));
  return recipes;
}

Future<List<Recipe>> getFavorites() async {
  await Future.delayed(const Duration(seconds: 3));
  return favorites;
}

Future<bool> isFavorite(Recipe recipeToCheck) async {
  await Future.delayed(const Duration(milliseconds: 500));
  for (Recipe recipe in favorites) {
    if (recipe == recipeToCheck) {
      return true;
    }
  }
  return false;
}

Future<List<Recipe>> getUserRecipes(User user) async {
  await Future.delayed(const Duration(seconds: 3));
  return recipes.where((recipe) {
    return recipe.user.id == user.id;
  }).toList();
}

Future<Recipe> addRecipe(Recipe nRecipe) async {
  nRecipe.id = recipes.length + 1;
  recipes.add(nRecipe);
  return nRecipe;
}

Future<Recipe> addFavorite(Recipe nFavorite) async {
  favorites.add(nFavorite);
  return nFavorite;
}

Future<bool> addUser(User nUser) async {
  nUser.id = users.length + 1;
  users.add(nUser);
  return true;
}

Future<bool> updateUser(User user) async {
  int pos = users.indexOf(user);
  if (pos >= 0) {
    users[pos] = user;
  }
  return true;
}

Future<bool> updateRecipe(Recipe recipe) async {
  int pos = recipes.indexOf(recipe);
  if (pos >= 0) {
    recipes[pos] = recipe;
  }
  return true;
}

Future<bool> deleteFavorite(Recipe favoriteRecipe) async {
  favorites.remove(favoriteRecipe);
  return true;
}

Future<User?> backendLogin(String nickname, String password) async {
  await Future.delayed(const Duration(seconds: 3));
  for (User user in users) {
    if (user.login(nickname, password)) {
      return user;
    }
  }
  return null;
}
