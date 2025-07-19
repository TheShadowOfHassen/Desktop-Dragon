import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const MyApp());

var buttonOne = 'Button One';
var buttonOneWebsites = ['https://github.com/'];
var buttonTwo = 'Button Two';
var buttonTwoWebsites = [
  'https://www.gamingonlinux.com/',
  'https://www.gamingonlinux.com/',
  'https://itsfoss.com/',
];

var buttonThree = 'MUSIC';
var buttonThreeWebsites = ['https://open.spotify.com/'];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Root widget
      home: Scaffold(
        appBar: AppBar(title: const Text('My Home Page')),
        body: Center(
          child: Builder(
            builder: (context) {
              return Column(
                children: [
                  Text(
                    '  ^^     /======>\n (00)   /      /\n@@=====>\n    J        J',
                  ),
                  const SizedBox(height: 20),
                  Row(
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
}

void open_urls(List urls) {
  for (var name in urls) {
    Uri url = Uri.parse(name);
    launchUrl(url);
  }
}
