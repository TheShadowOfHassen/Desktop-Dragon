import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:date_format/date_format.dart';
import 'dart:async';

void main() => runApp(DesktopDragon());

var buttonOne = 'Button One';
var buttonOneWebsites = ['https://github.com/'];
var buttonTwo = 'Button Two';
var buttonTwoWebsites = [
  'https://www.gamingonlinux.com/',
  'https://www.gamingonlinux.com/',
  'https://itsfoss.com/',
];
var label_time = 'dd';

var buttonThree = 'MUSIC';
var buttonThreeWebsites = ['https://open.spotify.com/'];

class DesktopDragon extends StatefulWidget {
  const DesktopDragon({super.key});

  @override
  State<DesktopDragon> createState() => _DesktopDragonState();
}

class _DesktopDragonState extends State<DesktopDragon> {
  String labelTime = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Update every second
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        labelTime = updateClock();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      // Root widget
      home: Scaffold(
        appBar: AppBar(title: const Text('Desktop Dragon')),
        body: Center(
          child: Builder(
            builder: (context) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(labelTime),
                      const SizedBox(width: 50),
                      Text(
                        '  ^^     /======>\n (00)   /      /\n@@=====>\n    J        J',
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          open_urls(buttonOneWebsites);
                        },
                        child: Text(buttonOne),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          open_urls(buttonTwoWebsites);
                        },
                        child: Text(buttonTwo),
                      ),

                      ElevatedButton(
                        onPressed: () {
                          open_urls(buttonThreeWebsites);
                        },
                        child: Text(buttonThree),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void open_urls(List urls) {
    for (var name in urls) {
      Uri url = Uri.parse(name);
      launchUrl(url);
    }
  }

  String updateClock() {
    var time = formatDate(DateTime.now(), [
      DD,
      ' ',
      MM,
      ' ',
      dd,
      ', ',
      yyyy,
      '\n',
      h,
      ':',
      n,
      ':',
      s,
      '  ',
      am,
    ]);
    return time;
  }
}
