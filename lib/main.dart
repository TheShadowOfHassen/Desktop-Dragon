//Desktop Dragon
// Copyright 2025 ShadowOfHassen
// This app is licensed under the GNU GPL 3.0
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
  WindowManager.instance.setTitleBarStyle(TitleBarStyle.hidden);
  WindowManager.instance.setMinimumSize(SIZE);
  WindowManager.instance.setMaximumSize(SIZE);
  WindowManager.instance.setSize(SIZE);
  await windowManager.setTitle('Roar!!!');
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
  List settingdata = [];
  @override
  void initState() {
    super.initState();
    // load app settings
    getSettingsData();

    labelTime = updateClock();
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

  Future<void> ShowSettingsDialog(context) async {
    //Name controlers
    var ButtonOneNameControler = TextEditingController();
    var ButtonTwoNameControler = TextEditingController();
    var ButtonThreeNameControler = TextEditingController();
    // URL Controllers
    var ButtonOneUrlControler = TextEditingController();
    var ButtonTwoUrlControler = TextEditingController();
    var ButtonThreeUrlControler = TextEditingController();

    ButtonOneNameControler.text = ButtonOneLabel;
    ButtonOneUrlControler.text = ButtonOneList.join(',');
    ButtonTwoNameControler.text = ButtonTwoLabel;
    ButtonTwoUrlControler.text = ButtonTwoList.join(',');
    ButtonThreeNameControler.text = ButtonThreeLabel;
    ButtonTwoUrlControler.text = ButtonTwoList.join(',');

    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: const Text('Settings'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Button Names:'),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Button 1 '),
                    const SizedBox(width: 20),
                    Expanded(
                      child: TextField(
                        controller: ButtonOneNameControler,
                        maxLength: 12,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Button 2'),
                    const SizedBox(width: 20),
                    Expanded(
                      child: TextField(
                        controller: ButtonTwoNameControler,
                        maxLength: 12,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Button 3'),
                    const SizedBox(width: 20),
                    Expanded(
                      child: TextField(
                        controller: ButtonThreeNameControler,
                        maxLength: 12,
                      ),
                    ),
                  ],
                ),
                Text('Button URLS:'),
                Text('Seperate with commas:'),
                Text('I.E url1, url2'),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Button 1'),
                    const SizedBox(width: 20),
                    Expanded(
                      child: TextField(controller: ButtonOneUrlControler),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Button 2'),
                    const SizedBox(width: 20),
                    Expanded(
                      child: TextField(controller: ButtonTwoUrlControler),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Button 3'),
                    const SizedBox(width: 20),
                    Expanded(
                      child: TextField(controller: ButtonThreeUrlControler),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text('Deskrop Dragon was made by:'),
                Text('Shadow Of Hassen'),
                InkWell(
                  onTap: () => launchUrl(
                    Uri.parse(
                      'https://github.com/TheShadowOfHassen/Desktop-Dragon',
                    ),
                  ),
                  child: Text(
                    'Click Here for the repo',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.blue,
                    ),
                  ),
                ),
                Text('If you like the app please give it a star!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                ButtonOneLabel = ButtonOneNameControler.text;
                ButtonOneList = ButtonOneUrlControler.text.split(',');
                ButtonTwoLabel = ButtonTwoNameControler.text;
                ButtonTwoList = ButtonTwoUrlControler.text.split(',');
                ButtonThreeLabel = ButtonThreeNameControler.text;
                ButtonThreeList = ButtonThreeUrlControler.text.split(',');
                var saveData = [
                  [ButtonOneLabel, ButtonOneList],
                  [ButtonTwoLabel, ButtonTwoList],
                  [ButtonThreeLabel, ButtonThreeList],
                ];
                saveSettings(saveData);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> getSettingsData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // For the first button
    String? buttonOnelabel = prefs.getString('button_oneLabel');
    if (buttonOnelabel == null) {
      buttonOnelabel = 'Github';
    }
    List<String>? buttonOnelist = prefs.getStringList('button_oneList');
    if (buttonOnelist == null) {
      buttonOnelist = <String>['https://github.com'];
    }
    // For the second button
    String? buttonTwolabel = prefs.getString('button_twoLabel');
    if (buttonTwolabel == null) {
      buttonTwolabel = 'UFC';
    }
    List<String>? buttonTwolist = prefs.getStringList('button_twoList');
    if (buttonTwolist == null) {
      buttonTwolist = <String>[
        'https://ubuntu-flutter-community.github.io/website/',
      ];
    }
    // For the third button
    String? buttonThreelabel = prefs.getString('button_threeLabel');
    if (buttonThreelabel == null) {
      buttonThreelabel = 'News';
    }
    List<String>? buttonThreelist = prefs.getStringList('button_threeList');
    if (buttonThreelist == null) {
      buttonThreelist = <String>[
        'https://www.gamingonlinux.com',
        'https://itsfoss.com',
        'https://www.omgubuntu.co.uk',
      ];
    }
    ButtonOneLabel = buttonOnelabel;
    ButtonOneList = buttonOnelist;
    ButtonTwoLabel = buttonTwolabel;
    ButtonTwoList = buttonTwolist;
    ButtonThreeLabel = buttonThreelabel;
    ButtonThreeList = buttonThreelist;
  }

  Future<void> saveSettings(data) async {
    //Labels
    String buttonOnelabel = data[0][0];
    String buttonTwolabel = data[1][0];
    String buttonThreelabel = data[2][0];
    //Lists
    List<String> buttonOnelist = data[0][1];
    List<String> buttonTwolist = data[1][1];
    List<String> buttonThreelist = data[1][1];
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //Save Labels
    await prefs.setString('button_oneLabel', buttonOnelabel);
    await prefs.setString('button_twoLabel', buttonTwolabel);
    await prefs.setString('button_threeLabel', buttonThreelabel);
    // Save Lists;
    await prefs.setStringList('button_oneList', buttonOnelist);
    await prefs.setStringList('button_twoList', buttonTwolist);
    await prefs.setStringList('button_threeList', buttonThreelist);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.maxFinite, 50),
        child: DragToMoveArea(
          child: AppBar(
            title: const Text('Desktop Dragon'),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.settings),
                tooltip: 'Show Settings',
                onPressed: () {
                  ShowSettingsDialog(context);
                },
              ),
              IconButton(
                icon: const Icon(Icons.close),
                tooltip: 'Close The App',
                onPressed: () {
                  //save the app
                  var saveData = [
                    [ButtonOneLabel, ButtonOneList],
                    [ButtonTwoLabel, ButtonTwoList],
                    [ButtonThreeLabel, ButtonThreeList],
                  ];
                  saveSettings(saveData).then((tempdata) {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  });
                },
              ),
            ],
          ),
        ),
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
      hh,
      ':',
      nn,
      ':',
      ss,
      '  ',
      am,
    ]);
    return time;
  }
}
