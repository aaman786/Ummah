import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';

class QiblaCompassScreen extends StatefulWidget {
  const QiblaCompassScreen({Key? key}) : super(key: key);

  @override
  State<QiblaCompassScreen> createState() => _QiblaCompassScreenState();
}

class _QiblaCompassScreenState extends State<QiblaCompassScreen> {
  // double? heading = 0;

  // @override
  // void initState() {
  //   super.initState();
  //   FlutterCompass.events!.listen((event) {
  //     setState(() {
  //       heading = event.heading;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("Qibla Location"),
      ),
      body: Builder(builder: (context) {
        return Column(
          children: <Widget>[
            Expanded(child: _buildCompass()),
          ],
        );
      }),
    );

    //  Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   crossAxisAlignment: CrossAxisAlignment.center,
    //   children: [
    //     Text(
    //       "${heading!.ceil()}",
    //       style: TextStyle(color: Colors.white),
    //     ),
    //     Padding(
    //       padding: EdgeInsets.all(18),
    //       child: Stack(
    //         alignment: Alignment.center,
    //         children: [
    //           Image.asset("assets/compass/cadrant.png"),
    //           Transform.rotate(
    //             angle: ((heading ?? 0) * (pi / 180) * -1),
    //             child: Image.asset(
    //               "assets/compass/compass.png",
    //               scale: 1.1,
    //             ),
    //           ),
    //         ],
    //       ),
    //     )
    //   ],
    // ),
  }

  Widget _buildCompass() {
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, AsyncSnapshot<CompassEvent> snapshot) {
        if (snapshot.hasError) {
          return Text('Error reading heading: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        double? direction = snapshot.data?.heading;

        // if direction is null, then device does not support this sensor
        // show error message
        if (direction == null) {
          return const Center(
            child: Text("Device does not have sensors !"),
          );
        }

        // int ang = (direction.round());
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "${direction.ceil()}",
              style: const TextStyle(color: Colors.white),
            ),
            Padding(
              padding:  const EdgeInsets.all(18),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset("assets/compass/cadrant.png"),
                  Transform.rotate(
                    angle: ((direction) * (pi / 180) * -1),
                    child: Image.asset(
                      "assets/compass/compass.png",
                      scale: 1.1,
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
