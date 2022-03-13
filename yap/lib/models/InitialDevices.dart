import 'package:flutter/foundation.dart';
import 'package:flutter_blue/flutter_blue.dart';

class InitialDevices extends ChangeNotifier {
  late BluetoothDevice _devices;

  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final List<BluetoothDevice> devicesList = <BluetoothDevice>[];
  final List<BluetoothDevice> connectedDevicesList = <BluetoothDevice>[];

  /// The current total price of all items.

  addConnectedDeviceTolist(final BluetoothDevice device) {
    // we don't want to add same devices to the list.
    if (!connectedDevicesList.contains(device)) {
      connectedDevicesList.add(device);
      notifyListeners();
    }
  }

  addDeviceTolist(final BluetoothDevice device) {
    if (!devicesList.contains(device)) {
      devicesList.add(device);
      notifyListeners();
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
