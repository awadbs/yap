import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:math';

// our pages
import 'package:yap/screens/InitialPage.dart';
import 'package:yap/models/InitialDevices.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => InitialDevices()),
        ],
        child: CupertinoApp(
          title: 'Yap',
          theme: CupertinoThemeData(
            primaryColor: Color.fromARGB(255, 12, 165, 114),
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => MyLogin(),
            '/blePage': (context) => const MyHomePage(title: 'Start Page'),
          },
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _Ble();
}

class _Ble extends State<MyHomePage> {
  List devices = [];
  bool isSwitched = false;
  var random = new Random();

  void findble() {
    FlutterBlue flutterBlue = FlutterBlue.instance;
    setState(() {
      // Start scanning
      flutterBlue.startScan(timeout: Duration(seconds: 4));

      // Listen to scan results
      var subscription = flutterBlue.scanResults.listen((results) {
        // do something with scan results
        for (ScanResult r in results) {
          devices.add('${r.device.name} found! rssi: ${r.rssi}\ni');
        }
      });

// Stop scanning
      flutterBlue.stopScan();
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Spacer(flex: 2),
            const Text(
              'Devices found:',
            ),
            Text(
              '$devices',
              style: Theme.of(context).textTheme.headline4,
            ),
            if (isSwitched)
              Transform.rotate(
                angle: random.nextInt(360) * pi / 180,
                child: Container(
                  width: 300.0,
                  height: 300.0,
                  decoration: new BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.arrow_upward_outlined, size: 80),
                ),
              ),
            Spacer(flex: 1),
            const Text('Search mode'),
            Switch(
              value: isSwitched,
              onChanged: (value) {
                setState(() {
                  isSwitched = value;
                  print(isSwitched);
                });
              },
              activeTrackColor: Colors.lightGreenAccent,
              activeColor: Colors.green,
            ),
            Spacer(flex: 2),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: findble,
        tooltip: 'Scan',
        child: const Icon(Icons.bluetooth_searching),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
