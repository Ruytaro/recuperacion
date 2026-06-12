import 'package:flutter/material.dart';
import 'package:recuperacion/controllers/image_service.dart';
import 'package:recuperacion/controllers/state_manager.dart';
import 'package:recuperacion/controllers/user_manager.dart';
import 'package:recuperacion/utils/validators.dart';
import 'package:recuperacion/widgets/buttons.dart';
import 'package:recuperacion/widgets/forms.dart';
import 'package:recuperacion/utils/notifications.dart';
import 'package:recuperacion/models/user.dart';
import 'package:recuperacion/widgets/images.dart';
import 'package:recuperacion/widgets/padding.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  UserManager um = UserManager();
  StateManager sm = StateManager();
  final formKey = GlobalKey<FormState>();
  String name = "";
  String pass = "";
  String pass2 = "";
  String age = "";
  final GalleryService _galleryService = GalleryService();
  String _imagePath = "";
  bool admin = false;
  void doRegister() {
    if (!formKey.currentState!.validate()) {
      Notifications.showError(context, "Review the form");
      return;
    }
    User newUser = User(name, pass);
    newUser.setAdmin(admin);

    if (um.register(newUser)) {
      Notifications.showMessage(context, "Account created");
      sm.set("home");
    } else {
      Notifications.showError(context, "Check user data");
    }
  }

  Future<void> _handleTakePhoto() async {
    final path = await _galleryService.takePhoto();
    setState(() {
      _imagePath = path!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Image.asset("images/logo.png", width: 150),
            myFormField((v) {
              name = v;
            }, "Username"),
            myFormField(
              (v) {
                pass = v;
              },
              "Password",
              obscure: true,
              validator: validateStrongPassword,
            ),
            edgePadding(
              TextFormField(
                onChanged: (value) => pass2,
                validator: (value) {
                  if (value != pass) {
                    return "Retype the password!";
                  }
                  return null;
                },
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Retype password",
                  border: OutlineInputBorder(),
                  constraints: BoxConstraints(maxWidth: 300),
                ),
              ),
            ),
            myElevatedButton(() => _handleTakePhoto(), Text("Set avatar")),
            if (_imagePath != "") myImageFile(_imagePath, 256),
            myFormField((v) => age, "Type your age", validator: validateNumber),
            if (um.isAdmin())
              SizedBox(
                width: 300,
                child: CheckboxListTile(
                  title: Text("Give admin to the new user"),
                  value: admin,
                  onChanged: (value) {
                    setState(() {
                      admin = value!;
                    });
                  },
                ),
              ),
            myElevatedButton(doRegister, Text("Create account")),
            if (!um.isLogged())
              myElevatedButton(() {
                sm.set("Login");
              }, Text("Go to Login")),
          ],
        ),
      ),
    );
  }
}
