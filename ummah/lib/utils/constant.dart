import 'package:flutter/material.dart';
import 'package:ummah/screens/addpost_screen.dart';
import 'package:ummah/screens/feed_sceen.dart';
import 'package:ummah/screens/qibla_compass_screen.dart';
// import 'package:random_color/random_color.dart';

Color kBackgroundClr = const Color.fromARGB(255, 71, 104, 101);

const homeNavigationBarItems = [
  FeedPage(),
  AddPost(),
  QiblaCompassScreen(),
];

Color kBgColourOfBars = Colors.blueGrey.withOpacity(0.5);

// Widget customizeCircleAvatar(String name, double rd) {
//   RandomColor randomColor = RandomColor();
//   Color color = randomColor.randomColor(colorBrightness: ColorBrightness.dark);

//   return CircleAvatar(
//     backgroundColor: color,
//     radius: rd,
//     child: Text(name),
//   );
// }
