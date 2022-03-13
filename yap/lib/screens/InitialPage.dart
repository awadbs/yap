// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:yap/models/InitialDevices.dart';
import 'package:yap/models/ListServices.dart';

class MyLogin extends StatelessWidget {
  const MyLogin({Key? key}) : super(key: key);
  BluetoothDevice setDeviceToTrack(BluetoothDevice dev) {
    InitialDevices().tracked = dev;
    return dev;
  }

  @override
  Widget build(BuildContext context) {
    FlutterBlue flutterBlue = FlutterBlue.instance;
    List<BluetoothService> _services;
    // once pressed, will navigate to the bluetooth next page.
    _goToNextPage() {
      Navigator.pushReplacementNamed(context, '/TargetPage');
    }

    // this creates a scan for devices
    scanForDevices() {
      var initDevices = context.read<InitialDevices>();

      flutterBlue.startScan(timeout: Duration(seconds: 2));
      flutterBlue.scanResults.listen((List<ScanResult> results) {
        for (ScanResult result in results) {
          initDevices.addDeviceTolist(result.device);
        }
      });
      print("end of scan list ");
      print(initDevices.devicesList.length);
    }

    Consumer buildListView() {
      return Consumer<InitialDevices>(
        builder: (context, devices, child) {
          return ListView.builder(
            itemCount: devices.devicesList.length,
            itemBuilder: (context, index) {
              return Container(
                height: 100,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Text(devices.devicesList[index].name == ''
                              ? '(No Device Name)'
                              : devices.devicesList[index].name),
                          Text(devices.devicesList[index].id.toString()),
                        ],
                      ),
                    ),
                    CupertinoButton(
                      color: Colors.blue,
                      child: Text(
                        'Select',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () =>
                          setDeviceToTrack(devices.devicesList[index]),
                    )
                  ],
                ),
              );
            },
          );
        },
      );
    }

    // container for display. main.
    return Consumer<InitialDevices>(builder: (context, devices, child) {
      return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Select Two Devices'),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 300,
                  child: buildListView(),
                ),
                const SizedBox(height: 30),
                CupertinoButton.filled(
                  onPressed: () => scanForDevices(),
                  child: const Text('Search '),
                ),
                const SizedBox(height: 30),
                CupertinoButton.filled(
                  onPressed: (!devices.areTwoDevicesConnected()
                      ? null
                      : () => _goToNextPage()),
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
