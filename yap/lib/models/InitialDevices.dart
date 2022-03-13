import 'package:flutter/foundation.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';
import 'dart:collection';

class InitialDevices extends ChangeNotifier {
  late BluetoothDevice _devices;

  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final List<BluetoothDevice> devicesList = <BluetoothDevice>[];

  //final List<BluetoothDevice> connectedDevicesList = <BluetoothDevice>[];
  Map<BluetoothDevice, List<BluetoothService>> connectedDevicesList =
      new HashMap();

  /// The current total price of all items.

  addConnectedDeviceTolist(
      final BluetoothDevice device, List<BluetoothService> service) {
    // we don't want to add same devices to the list.
    if (!connectedDevicesList.containsKey(device)) {
      connectedDevicesList[device] = service;
      notifyListeners();
    }
  }

  addDeviceTolist(final BluetoothDevice device) {
    if (!devicesList.contains(device)) {
      devicesList.add(device);
      notifyListeners();
    }
  }

  isConnected(final BluetoothDevice device) {
    if (connectedDevicesList.containsKey(device)) {
      return true;
    } else {
      return false;
    }
  }

  areTwoDevicesConnected() {
    if (connectedDevicesList.length >= 2) {
      return true;
    } else {
      return false;
    }
  }
}
