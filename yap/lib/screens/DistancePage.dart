// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:yap/models/InitialDevices.dart';
import 'package:yap/models/ListServices.dart';

class DistancePage extends StatelessWidget {
  const DistancePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FlutterBlue flutterBlue = FlutterBlue.instance;
    var rssiReading = 70 % 15;
    scanForDevices() {
      var initDevices = context.read<InitialDevices>();
      initDevices.resetDevicesList();
      flutterBlue.startScan(timeout: Duration(seconds: 2));
      flutterBlue.scanResults.listen((List<ScanResult> results) {
        for (ScanResult result in results) {
          initDevices.addDeviceTolist(result.device);
        }
      });
    }

    return Consumer<InitialDevices>(builder: (context, devices, child) {
      return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Distance calculation'),
        ),
        child: Center(
          child: Container(
            height: 250,
            width: 250,
            padding: const EdgeInsets.all(10.0),
            child: Text(rssiReading.toString() + "ft."),
          ),
        ),
      );
    });
  }
}
