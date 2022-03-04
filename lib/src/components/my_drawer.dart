import 'package:flutter/material.dart';

import '../connection/server_controller.dart';

class MyDrawer extends StatelessWidget {
  final ServerController serverController;

  const MyDrawer({required this.serverController, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  '/images/drawer-background.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
            accountName: Text(
              serverController.loggedUser!.nickname,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            currentAccountPicture: serverController.loggedUser!.photo != null
                ? CircleAvatar(
                    backgroundImage: FileImage(
                      serverController.loggedUser!.photo!,
                    ),
                  )
                : CircleAvatar(
                    backgroundImage: AssetImage(
                      serverController.loggedUser!.assets!,
                    ),
                  ),
            onDetailsPressed: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed("/register",
                  arguments: serverController.loggedUser);
            },
            accountEmail: null,
          ),
          ListTile(
            title: const Text(
              "Mis recetas",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            leading: const Icon(
              Icons.book,
              color: Colors.green,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed("/my_recipes");
            },
          ),
          ListTile(
            title: const Text(
              "Mis favoritos",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            leading: const Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed("/favorites");
            },
          ),
          ListTile(
            title: const Text(
              "Cerar sesión",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            leading: const Icon(
              Icons.power_settings_new,
              color: Colors.cyan,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, "/");
            },
          ),
        ],
      ),
    );
  }
}
