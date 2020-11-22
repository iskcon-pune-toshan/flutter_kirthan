
class Screens {
  final int id;
  String screenName;


//Typically called form service layer
  Screens({this.id, this.screenName,
  });

//Typically called from the data_source layer after getting data from an external source.
  factory Screens.fromJson(Map<String, dynamic> data) {
    return Screens(
        id: data['id'],
        screenName: data['screenName'],

    );
  }

  factory Screens.fromMap(Map<String, dynamic> map) {
    return Screens(
      id: map['id'],
      screenName: map['screenName'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['screenName']=this.screenName;
    return data;
  }

  Map toStrJson() {
    return {
      "id": this.id,
      "screenName":this.screenName,

    };
  }



}