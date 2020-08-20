import 'package:shared_preferences/shared_preferences.dart';

mixin CommonUtils {
  /*
  SharedPreferences prefs;
  List<String> access;
  Map<String,bool> accessTypes = new Map<String,bool>();


  void loadPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      access = prefs.getStringList(widget.screenName);
      access.forEach((f) {
        List<String> access = f.split(":");
        accessTypes[access.elementAt(0)] =  access.elementAt(1).toLowerCase() == "true" ? true:false;
      });
      eventPageVM.accessTypes = accessTypes;
    });
  }
*/
}