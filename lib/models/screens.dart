
class Screens {
  final int id;
  String screen_name;


//Typically called form service layer
  Screens({this.id, this.screen_name,
  });

//Typically called from the data_source layer after getting data from an external source.
  factory Screens.fromJson(Map<String, dynamic> data) {
    return Screens(
        id: data['id'],
        screen_name: data['screen_name']

    );
  }

  factory Screens.fromMap(Map<String, dynamic> map) {
    return Screens(
      id: map['id'],
      screen_name: map['screen_name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['screen_name']=this.screen_name;
    return data;
  }

  Map toStrJson() {
    return {
      "id": this.id,
      "screen_name":this.screen_name

    };
  }

}