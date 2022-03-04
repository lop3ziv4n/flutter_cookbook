import 'dart:io';

import 'package:flutter/material.dart';

import '../components/image_picker_widget.dart';
import '../connection/server_controller.dart';
import '../fake_backend/user.dart';

class RegisterPage extends StatefulWidget {
  ServerController serverController;
  BuildContext context;
  User? userToEdit;

  RegisterPage(this.serverController, this.context, {Key? key, this.userToEdit})
      : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final bool _loading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffKey = GlobalKey<ScaffoldState>();

  String userName = "";
  String password = "";
  Gender gender = Gender.MALE;

  final String _errorMessage = "";
  File? imageFile;
  String? assertPath;
  bool showPassword = false;
  bool editingUser = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffKey,
      body: Form(
        key: _formKey,
        child: Stack(
          children: <Widget>[
            ImagePickerWidget(
              imageFile: imageFile,
              assetPath: assertPath,
              onImageSelected: (File file) {
                setState(() {
                  imageFile = file;
                });
              },
            ),
            SizedBox(
              child: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              height: kToolbarHeight + 25,
            ),
            Center(
              child: Transform.translate(
                offset: const Offset(0, -40),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  margin: const EdgeInsets.only(
                      left: 20, right: 20, top: 260, bottom: 20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 35, vertical: 20),
                    child: ListView(
                      //mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextFormField(
                          initialValue: userName,
                          decoration:
                              const InputDecoration(labelText: "Usuario:"),
                          onSaved: (value) {
                            userName = value!;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Este campo es obligatorio";
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          initialValue: password,
                          decoration: InputDecoration(
                              labelText: "Contraseña:",
                              suffixIcon: IconButton(
                                icon: Icon(showPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    showPassword = !showPassword;
                                  });
                                },
                              )),
                          obscureText: !showPassword,
                          onSaved: (value) {
                            password = value!;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Este campo es obligatorio";
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Género",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700]),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  RadioListTile(
                                    title: const Text(
                                      "Masculino",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    value: Gender.MALE,
                                    groupValue: gender,
                                    onChanged: (value) {
                                      setState(
                                        () {
                                          gender = value as Gender;
                                        },
                                      );
                                    },
                                  ),
                                  RadioListTile(
                                    title: const Text(
                                      "Femenino",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    value: Gender.FEMALE,
                                    groupValue: gender,
                                    onChanged: (value) {
                                      setState(
                                        () {
                                          gender = value as Gender;
                                        },
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Theme(
                          data: Theme.of(context).copyWith(
                            primaryColor: Colors.white,
                          ),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).primaryColor,
                              ),
                              textStyle: MaterialStateProperty.all(
                                const TextStyle(color: Colors.white),
                              ),
                              padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(vertical: 15),
                              ),
                            ),
                            onPressed: () => _doProcess(context),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                    (editingUser) ? "Actualizar" : "Registrar"),
                                if (_loading)
                                  Container(
                                    height: 20,
                                    width: 20,
                                    margin: const EdgeInsets.only(left: 20),
                                    child: const CircularProgressIndicator(),
                                  )
                              ],
                            ),
                          ),
                        ),
                        if (_errorMessage.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              _errorMessage,
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _doProcess(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (imageFile == null) {
        _showSnackBar(
            context, "Seleccione una imágen por favor", Colors.orange);
        return;
      }
      User user = User(
          gender: gender,
          nickname: userName,
          password: password,
          photo: imageFile!);
      bool state;
      if (editingUser) {
        user.id = widget.serverController.loggedUser!.id;
        state = await widget.serverController.updateUser(user);
      } else {
        state = await widget.serverController.addUser(user);
      }
      final action = editingUser ? "actualizar" : "guardar";
      final action2 = editingUser ? "actualizado" : "guardado";

      if (state == false) {
        _showSnackBar(context, "No se pudo $action", Colors.orange);
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Información"),
              content: Text("Su usuario ha sido $action2 exitosamente"),
              actions: <Widget>[
                TextButton(
                  child: const Text("Ok"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                )
              ],
            );
          },
        );
      }
    }
  }

  void _showSnackBar(BuildContext context, String title, Color backColor) {
    SnackBar snackBar = SnackBar(
      content: Text(
        title,
        textAlign: TextAlign.center,
      ),
      backgroundColor: backColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
    editingUser = (widget.userToEdit != null);

    if (editingUser) {
      userName = widget.userToEdit!.nickname;
      password = widget.userToEdit!.password;
      imageFile = widget.userToEdit!.photo;
      assertPath = widget.userToEdit!.assets;
      gender = widget.userToEdit!.gender;
    }
  }
}
