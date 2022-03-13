import 'package:flutter/foundation.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';

class Person with ChangeNotifier {
  int age = 0;

  void increaseAge() {
    this.age++;
    print("increased age..." + age.toString());
    notifyListeners();
  }
}
