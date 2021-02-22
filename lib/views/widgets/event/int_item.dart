import 'package:flutter/material.dart';
//import 'package:flutter_kirthan/location/home.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/event_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/display_settings.dart';
import 'package:flutter_kirthan/views/pages/event/event_edit.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_kirthan/views/pages/event/event_location.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'Interested_events.dart';
import 'event_list_item.dart';

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