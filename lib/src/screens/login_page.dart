import 'package:flutter/material.dart';

import '../connection/server_controller.dart';
import '../fake_backend/user.dart';

class LoginPage extends StatefulWidget {
  ServerController serverController;
  BuildContext context;

  LoginPage(this.serverController, this.context, {Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _loading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String userName = "";
  String password = "";

  String _errorMessage = "";

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 60),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.cyan.shade300,
                    Colors.cyan.shade800,
                  ],
                ),
              ),
              child: Image.asset(
                "assets/images/logo.png",
                color: Colors.white,
                height: mediaQuery.size.height * 0.20,
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -40),
              child: Center(
                child: SingleChildScrollView(
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 260,
                      bottom: 20,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 35,
                        vertical: 20,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: "Usuario:"),
                            onSaved: (value) {
                              userName = value as String;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Este campo es obligatorio";
                              }
                            },
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Contraseña:",
                            ),
                            obscureText: true,
                            onSaved: (value) {
                              password = value as String;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Este campo es obligatorio";
                              }
                            },
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Theme(
                            data: Theme.of(context)
                                .copyWith(primaryColor: Colors.white),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).primaryColor,
                                ),
                                textStyle: MaterialStateProperty.all(
                                  const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(
                                    vertical: 15,
                                  ),
                                ),
                              ),
                              onPressed: () => _login(context),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  const Text("Iniciar sesión"),
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
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Expanded(
                                child: Text(
                                  '¿No estas registrado?',
                                ),
                              ),
                              TextButton(
                                style: ButtonStyle(
                                  textStyle: MaterialStateProperty.all(
                                    const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                child: const Text("Registrarse"),
                                onPressed: () => _showRegister(context),
                              )
                            ],
                          )
                        ],
                      ),
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

  void _login(BuildContext context) async {
    if (!_loading) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        setState(() {
          _loading = true;
          _errorMessage = "";
        });
        User? user = await widget.serverController.login(userName, password);
        if (user != null) {
          Navigator.of(context).pushReplacementNamed("/home", arguments: user);
        } else {
          setState(() {
            _errorMessage = "Usuario o contrasaeña incorrecto";
            _loading = false;
          });
        }
      }
    }
  }

  void _showRegister(BuildContext context) async {
    Navigator.of(context).pushNamed('/register');
  }

  @override
  void initState() {
    super.initState();
    widget.serverController.init();
  }
}
