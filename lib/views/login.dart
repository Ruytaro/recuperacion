import 'package:flutter/material.dart';
import 'package:recuperacion/controllers/user_manager.dart';
import 'package:recuperacion/controllers/state_manager.dart';
import 'package:recuperacion/widgets/forms.dart';
import 'package:recuperacion/widgets/buttons.dart';
import 'package:recuperacion/utils/notifications.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late UserManager _userManager;
  late StateManager _stateManager;

  String _name = "";
  String _pass = "";

  @override
  void initState() {
    super.initState();
    _initializeManagers();
  }

  void _initializeManagers() {
    _userManager = UserManager();
    _stateManager = StateManager();
  }

  Widget _getPassword(String username) {
    String? pass = _userManager.recoverPassword(username);
    if (pass != null) {
      return Text("Password is: $pass");
    } else {
      return Text("User not found");
    }
  }

  Future<void> _showPassword(String? username) async {
    if (!mounted) return;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Account recovery'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("This is what we know about $username"),
                _getPassword(username!),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _promptUsername() async {
    if (!mounted) return;

    String? username;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Account recovery'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text("We're going to recover your password"),
                const SizedBox(height: 10),
                const Text('Please type your username:'),
                const SizedBox(height: 5),
                myFormField((value) {
                  username = value;
                }, "Username"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Search'),
              onPressed: () {
                Navigator.of(context).pop();
                _showPassword(username);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _doLogin() async {
    if (_name.isEmpty || _pass.isEmpty) {
      Notifications.showError(context, "Please fill all fields");
      return;
    }
    try {
      if (_userManager.logIn(_name, _pass)) {
        _stateManager.set("home");
        Notifications.showMessage(context, "Logged in successfully");
      } else {
        _stateManager.set("login");
        Notifications.showError(context, "Check credentials");
      }
    } catch (e) {
      Notifications.showError(context, "Login error: $e");
    }
  }

  void _goToRegister() {
    _stateManager.set("register");
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              "images/logo.png",
              width: 150,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 150,
                  height: 150,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, size: 50),
                );
              },
            ),

            const SizedBox(height: 30),

            // Form fields
            myFormField((v) {
              _name = v;
            }, "name"),
            myFormField(
              (v) {
                _pass = v;
              },
              "pass",
              obscure: true,
            ),

            myElevatedButton(_doLogin, const Text("Login")),

            const SizedBox(height: 10),

            // Register button
            myElevatedButton(_goToRegister, const Text("Register")),

            const SizedBox(height: 10),

            // Recover account button (conditional)
            if (_userManager.hasFailedLogins())
              myElevatedButton(_promptUsername, const Text("Recover account")),
          ],
        ),
      ),
    );
  }
}
