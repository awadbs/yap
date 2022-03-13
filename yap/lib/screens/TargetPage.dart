import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:yap/models/InitialDevices.dart';
import 'package:yap/models/ListServices.dart';

class TargetPage extends StatelessWidget {
  const TargetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FlutterBlue flutterBlue = FlutterBlue.instance;
    List<BluetoothService> _services;

    _goToNextPage() {
      Navigator.pushReplacementNamed(context, '/DistancePage');
    }

    scanForDevices() {
      var initDevices = context.read<InitialDevices>();
      initDevices.resetDevicesList();
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
                        'Connect',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed:
                          devices.isTargetConnected(devices.devicesList[index])
                              ? null
                              : () async {
                                  flutterBlue.stopScan();
                                  try {
                                    await devices.devicesList[index].connect();
                                  } catch (e) {
                                    // if (e.code != 'already_connected') {
                                    //   throw e;
                                    // }
                                    print(e);
                                  } finally {
                                    _services = await devices.devicesList[index]
                                        .discoverServices();
                                  }

                                  devices.addTargetDeviceTolist(
                                      devices.devicesList[index], _services);
                                },
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    }

    return Consumer<InitialDevices>(builder: (context, devices, child) {
      return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Select Target Device to Locate'),
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
                  onPressed: (!devices.isTargetConnectedNext()
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
