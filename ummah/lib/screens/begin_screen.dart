import 'package:flutter/material.dart';

import '../utils/constant.dart';

class BeginPage extends StatelessWidget {
  const BeginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundClr,
      body: Container(
          padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: const [
                  Text(
                    "Welcome",
                    style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Providding the ordinary page for the sign in process.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height / 2,
                decoration: const BoxDecoration(
                    image:
                        DecorationImage(image: AssetImage("assets/home1.png"))),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, "login"),
                style: ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  minimumSize: MaterialStateProperty.all(
                      const Size(double.infinity, 55)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: Colors.white, width: 2)),
                  ),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                      color: Colors.white, fontSize: 26, letterSpacing: 2),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          )),
    );
  }
}
