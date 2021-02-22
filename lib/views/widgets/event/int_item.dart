import 'package:flutter/material.dart';


class int_item with ChangeNotifier {
  List itemlist = [];

  String get index => null;

  addtoitem(String index) {
    itemlist.add(index);
    notifyListeners();
  }

  removeitem(String index) {
    itemlist.remove(index);
    notifyListeners();
  }

  valitem(String index) {
    removeitem(index);

    // }
  }
}