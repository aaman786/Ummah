import 'package:flutter/material.dart';
import 'package:ummah/methods/auth_methods.dart';
import '../utils/constant.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController firstNameController = TextEditingController();

  final TextEditingController lastNameController = TextEditingController();

  final TextEditingController usernameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController conformPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // final _auth = FirebaseAuth.instance

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    conformPasswordController.dispose();
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
                padding: const EdgeInsets.only(top: 30, bottom: 20),
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
                    textFormField(
                        firstNameController, Icons.account_circle, "First Name",
                        ((value) {
                      RegExp regExp = RegExp(r'.{3,}$');
                      if (value!.isEmpty) {
                        return "Enter your first name.";
                      }
                      if (!regExp.hasMatch(value)) {
                        return "Please Enter a valid name(Min. 3 charachters).";
                      }
                      return null;
                    }), false),
                    textFormField(
                        lastNameController, Icons.account_circle, "Last Name",
                        ((value) {
                      if (value!.isEmpty) {
                        return "Enter your last name.";
                      }
                      return null;
                    }), false),
                    textFormField(usernameController, Icons.abc, "Username",
                        ((value) {
                      // RegExp regExp = RegExp(r'^.{6,}$');
                      if (value!.isEmpty) {
                        return "Please enter a username.";
                      }
                      if (value == "aaman07860") {
                        return "Select another user name.";
                      }

                      return null;
                    }), false),
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
                    textFormField(conformPasswordController, Icons.password,
                        "Confirm Password", ((value) {
                      if (value != passwordController.text) {
                        return "Please check! password and conform password.";
                      }
                      return null;
                    }), true),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      child: TextButton(
                          onPressed: () {
                            signUp();
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blueGrey),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            minimumSize: MaterialStateProperty.all(
                                const Size(double.infinity, 55)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  side: const BorderSide(
                                      color: Colors.white, width: 2)),
                            ),
                          ),
                          child: const Text(
                            'Singup',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                letterSpacing: 2),
                            textAlign: TextAlign.center,
                          )),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding textFormField(TextEditingController controller, IconData iconData,
      String hintText, String? Function(String?)? validator, bool obscure) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextFormField(
        style: const TextStyle(
            color: Colors.black54, fontSize: 26, fontWeight: FontWeight.w500),
        autofocus: false,
        obscureText: obscure,
        validator: validator,
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

  // Future<void> signUp(String email, String password) async {
  //   if (_formKey.currentState!.validate()) {
  //     await _auth
  //         .createUserWithEmailAndPassword(email: email, password: password)
  //         .then((value) => {postingDetailsToFirebase()})
  //         .catchError((e) {
  //       Fluttertoast.showToast(msg: e!.message);
  //     });
  //   }
  // }

  // Future<void> postingDetailsToFirebase() async {
  //   FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  //   User? user = _auth.currentUser;

  //   UserModel userModel = UserModel();

  //   userModel.email = user!.email;
  //   userModel.firstName = firstNameController.text;
  //   userModel.lastName = lastNameController.text;
  //   userModel.username = usernameController.text;
  //   userModel.uid = user.uid;

  //   await firebaseFirestore
  //       .collection("users")
  //       .doc(user.uid)
  //       .set(userModel.toMap());
  //   Fluttertoast.showToast(msg: "Account created sucessfully. :)");
  //   Navigator.pushNamedAndRemoveUntil(context, "home", (route) => false);
  // }

  Future<void> signUp() async {
    if (_formKey.currentState!.validate()) {
      await AuthMethods().creatingUser(
          emailController.text,
          passwordController.text,
          firstNameController.text,
          lastNameController.text,
          usernameController.text);
      Navigator.pushNamedAndRemoveUntil(context, "home", (route) => false);
    }
  }
}
