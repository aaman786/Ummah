import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../utils/constant.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController usernameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;

  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          currentFocus.focusedChild!.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: kBackgroundClr,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 70, bottom: 20),
                child: Container(
                  height: MediaQuery.of(context).size.height / 4,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/login.png"))),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    textFormField(emailController, Icons.email, "Email",
                        ((value) {
                      if (value!.isEmpty) {
                        return "Please Enter your Email.";
                      }
                      if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                          .hasMatch(value)) {
                        return "Please Enter a valid Email.";
                      }
                      return null;
                    }), false),
                    textFormField(
                        usernameController, Icons.abc, "Username", null, false),
                    textFormField(
                        passwordController, Icons.password, "Password",
                        ((value) {
                      RegExp regExp = RegExp(r'^.{6,}$');
                      if (value!.isEmpty) {
                        return "password is required for loggin";
                      }
                      if (!regExp.hasMatch(value)) {
                        return "Please Enter a valid password(Min. 6 charachters).";
                      }
                      return null;
                    }), true),
                    textButton(
                        "Login",
                        () => signIn(
                            emailController.text, passwordController.text)),
                    textButton(
                        "Signup", () => Navigator.pushNamed(context, "signup")),
                    Container(
                      padding: const EdgeInsets.only(top: 30),
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                              color: Colors.black54,
                              strokeWidth: 6,
                            ))
                          : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding textButton(String label, Function()? onpressed) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
      child: TextButton(
          onPressed: onpressed,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            minimumSize:
                MaterialStateProperty.all(const Size(double.infinity, 55)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: const BorderSide(color: Colors.white, width: 2)),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(
                color: Colors.white, fontSize: 26, letterSpacing: 2),
            textAlign: TextAlign.center,
          )),
    );
  }

  Padding textFormField(TextEditingController controller, IconData iconData,
      String hintText, String? Function(String?)? validate, bool obscure) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextFormField(
        style: const TextStyle(
            color: Colors.black54, fontSize: 26, fontWeight: FontWeight.w500),
        validator: validate,
        autofocus: false,
        obscureText: obscure,
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        onSaved: ((newValue) {
          controller.text = newValue!;
        }),
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.amber)),
          errorStyle: const TextStyle(
              color: Colors.amber, fontSize: 16, fontWeight: FontWeight.w600),
          prefixIcon: Icon(
            iconData,
            color: Colors.white,
            size: 30,
          ),
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 2)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white70, fontSize: 30),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.white,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }

  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                Fluttertoast.showToast(msg: "Login Sucessfull..."),
                setState(() => isLoading = false),
                Navigator.pushNamedAndRemoveUntil(
                    context, 'home', (route) => false)
              })
          .catchError((e) {
        setState(() => isLoading = false);
        Fluttertoast.showToast(msg: e.message);
      });
    }
  }
}
