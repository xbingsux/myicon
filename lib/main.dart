import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dynamic_icon_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Dynamic Icon Test')),
        body: Home(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final DynamicIconService _iconService = DynamicIconService();
  TextEditingController controller = TextEditingController();

  Future<void> getIconName() async {
    final iconName = await _iconService.getAlternateIconName();
    print('Current Icon Name: ${iconName ?? "Primary Icon"}');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: Platform.isIOS,
            child: TextField(
              controller: controller,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp("\\d+")),
              ],
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: "Set Batch Icon Number",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    if (Platform.isIOS) {
                      await _iconService.setApplicationIconBadgeNumber(
                          int.parse(controller.text));
                    }
                  },
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              bool isSupported = await _iconService.supportsAlternateIcons();
              print('Supports Alternate Icons: $isSupported');
            },
            child: Text('Check Icon Support'),
          ),
          ElevatedButton(
            onPressed: () async {
              await getIconName();
            },
            child: Text('get icon name'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _iconService.setAlternateIconName('ChristmasIcon',
                  showAlert: false);
              // print('Icon Changed to christmas');
            },
            child: Text('christmas Icon'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _iconService.setAlternateIconName('NewyearIcon',
                  showAlert: false);
              // print('Icon Changed to newyear');
            },
            child: Text('newyear Icon'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _iconService.setAlternateIconName('HelloIcon',
                  showAlert: false);
              // print('HelloIcon');
            },
            child: Text('HelloIcon'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _iconService.setAlternateIconName(null, showAlert: false);
              // print('Primary');
            },
            child: Text('Primary'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _iconService.setApplicationIconBadgeNumber(5);
              print('Badge Number Set to 5');
            },
            child: Text('Set Badge Number to 5'),
          ),
        ],
      ),
    );
  }
}
