import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:date_format/date_format.dart';
import 'dart:async';
import 'package:window_manager/window_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

const SIZE = Size(400, 400);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  //WindowManager.instance.setTitleBarStyle(TitleBarStyle.hidden);
  // This needs to be hidden so we can drag it around
  WindowManager.instance.setMinimumSize(SIZE);
  WindowManager.instance.setMaximumSize(SIZE);
  WindowManager.instance.setSize(SIZE);
  runApp(
    MaterialApp(
      title: 'Desktop Dragon',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Define the default brightness and colors.
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 3, 3, 3),
          brightness: Brightness.dark,
        ),
        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          displayLarge: const TextStyle(fontSize: 72),
          // ···
          titleLarge: GoogleFonts.getFont('IBM Plex Mono'),
          bodyMedium: GoogleFonts.getFont('IBM Plex Mono'),
          displaySmall: GoogleFonts.getFont('IBM Plex Mono'),
        ),
      ),
      home: DesktopDragon(),
    ),
  );
}

var data = [
  [
    'Button One',
    ['https://github.com/'],
  ],
  [
    'Button Two',
    ['https://www.gamingonlinux.com/'],
  ],
  [
    'Music',
    ['open.spotify.com'],
  ],
];

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

class DesktopDragon extends StatefulWidget {
  const DesktopDragon({super.key});

  @override
  State<DesktopDragon> createState() => _DesktopDragonState();
}

class _DesktopDragonState extends State<DesktopDragon> {
  String labelTime = '';
  String ButtonOneLabel = '';
  List ButtonOneList = [];
  String ButtonTwoLabel = '';
  List ButtonTwoList = [];
  String ButtonThreeLabel = '';
  List ButtonThreeList = [];
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Desktop Dragon'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Show Settings',
            onPressed: () {
              _showMyDialog(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.close),
            tooltip: 'Close The App',
            onPressed: () {
              //save the app
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            },
          ),
        ],
      ),

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
                      '  ^^     /=====/\n (00)   /     /\n@@=============\\\n    J      J   V',
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        open_urls(ButtonOneList);
                      },
                      child: Text(ButtonOneLabel),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        open_urls(ButtonTwoList);
                      },
                      child: Text(ButtonTwoLabel),
                    ),

                    ElevatedButton(
                      onPressed: () {
                        open_urls(ButtonThreeList);
                      },
                      child: Text(ButtonThreeLabel),
                    ),
                  ],
                ),
              ],
            );
          },
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

Future<List> getData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // For the first button
  String? button_oneLabel = prefs.getString('button_oneLabel');
  if (button_oneLabel == null) {
    button_oneLabel = 'Button One';
  }
  ;
  List<String>? button_oneList = prefs.getStringList('button_oneList');
  if (button_oneList == null) {
    var button_oneList = <String>['github.com'];
  }
  ;
  // For the second button
  String? button_twoLabel = prefs.getString('button_twoLabel');
  if (button_twoLabel == null) {
    button_twoLabel = 'Button Two';
  }
  ;
  List<String>? button_twoList = prefs.getStringList('button_twoList');
  if (button_twoList == null) {
    var button_twoList = <String>[
      'https://ubuntu-flutter-community.github.io/website/',
    ];
  }
  ;
  // For the third button
  String? button_threeLabel = prefs.getString('button_threeLabel');
  if (button_threeLabel == null) {
    button_threeLabel = 'Button Three';
  }
  ;
  List<String>? button_threeList = prefs.getStringList('button_threeList');
  if (button_threeList == null) {
    button_threeList = <String>['https://github.com/TheShadowOfHassen'];
  }
  ;

  var data = [
    [button_oneLabel, button_oneList],
    [button_twoLabel, button_twoList],
    [button_threeLabel, button_threeList],
  ];
  return data;
}

Future<void> _showMyDialog(context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        scrollable: true,
        title: const Text('AlertDialog Title'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Row(children: [Text('Button One: Name'), TextField()]),
              Text('This is a demo alert dialog.'),
              Text('Would you like to approve of this message?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Approve'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
