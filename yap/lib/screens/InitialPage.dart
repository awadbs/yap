// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:yap/models/InitialDevices.dart';

class MyLogin extends StatelessWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const twoDevicesConnected = false;
    var initDevices = context.read<InitialDevices>();
    bool areTwoConnected = initDevices.areTwoDevicesConnected();
    List<BluetoothService> _services;
    // once pressed, will navigate to the bluetooth next page.
    _goToNextPage() {
      Navigator.pushReplacementNamed(context, '/blePage');
    }

    // this creates a scan for devices
    scanForDevices() {
      FlutterBlue flutterBlue = FlutterBlue.instance;

      flutterBlue.startScan(timeout: Duration(seconds: 2));
      flutterBlue.scanResults.listen((List<ScanResult> results) {
        for (ScanResult result in results) {
          initDevices.addDeviceTolist(result.device);
        }
      });
      print("end of scan list ");
      print(initDevices.devicesList.length);

      flutterBlue.stopScan();
    }

    Consumer buildListView() {
      return Consumer<InitialDevices>(
        builder: (context, devices, child) {
          List<Container> containers = <Container>[];
          for (BluetoothDevice device in initDevices.devicesList) {
            Container(
              height: 50,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Text(device.name == ''
                            ? '(No Device Name)'
                            : device.name),
                        Text(device.id.toString()),
                      ],
                    ),
                  ),
                  CupertinoButton(
                    color: Colors.blue,
                    child: Text(
                      'Connect',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      try {
                        await device.connect();
                      } catch (e) {
                        // if (e.code != 'already_connected') {
                        //   throw e;
                        // }
                        print(e);
                      } finally {
                        _services = await device.discoverServices();
                      }

                      initDevices.addConnectedDeviceTolist(device);
                    },
                  ),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(8),
            shrinkWrap: true, // <- added
            primary: false, // <- added
            children: <Widget>[
              ...containers,
            ],
          );
        },
      );
    }

    // container for display. main.
    return Consumer<InitialDevices>(builder: (context, devices, child) {
      return CupertinoPageScaffold(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SingleChildScrollView(
                  child: buildListView(),
                ),
                const SizedBox(height: 30),
                CupertinoButton.filled(
                  onPressed: () => scanForDevices(),
                  child: const Text('Search '),
                ),
                const SizedBox(height: 30),
                CupertinoButton.filled(
                  onPressed: (!areTwoConnected ? null : () => _goToNextPage()),
                  child: Text('Continue'),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
