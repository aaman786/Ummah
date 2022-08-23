import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ummah/utils/constant.dart';
import 'package:ummah/providers/user_proider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // User? user = FirebaseAuth.instance.currentUser;

  String name = "";

  Future<void> getUserData() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();
    // here value get stored in UserProvider class
  }

  int _page = 0;

  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    getUserData();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void pageChanged(int page) {
    setState(() => _page = page);
  }

  @override
  Widget build(BuildContext context) {
    // UserModel? user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      backgroundColor: kBackgroundClr,
      // body: Center(child: const Text("This is the App.")),
      body: PageView(
        controller: pageController,
        onPageChanged: pageChanged,
        children: homeNavigationBarItems,
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            // bottomNavigationTapped(index);
            navigationTapped(index);
          },
          currentIndex: _page,
          selectedItemColor: Colors.black54,
          unselectedItemColor: Colors.white,
          showUnselectedLabels: false,
          selectedFontSize: 16,
          elevation: 3,
          iconSize: 32,
          backgroundColor: Color.fromARGB(255, 17, 130, 182),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_box), label: "Add Post"),
            BottomNavigationBarItem(
                icon: Icon(Icons.navigation_rounded), label: "home"),
          ]),
    );
  }
}
