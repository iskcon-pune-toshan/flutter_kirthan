class Preferences {
  final int id;
  int userId;
  String area;
  String localAdmin;
  int eventDuration;
  String requestAcceptance;

//Typically called form service layer
  Preferences(
      {this.id,
      this.userId,
      this.area,
      this.localAdmin,
      this.eventDuration,
      this.requestAcceptance});

//Typically called from the data_source layer after getting data from an external source.
  factory Preferences.fromJson(Map<String, dynamic> data) {
    return Preferences(
      id: data['id'],
      userId: data['userId'],
      area: data['area'],
      localAdmin: data['localAdmin'],
      eventDuration: data['eventDuration'],
      requestAcceptance: data['requestAcceptance'],
    );
  }

  factory Preferences.fromMap(Map<String, dynamic> map) {
    return Preferences(
      id: map['id'],
      userId: map['userId'],
      area: map['area'],
      localAdmin: map['localAdmin'],
      eventDuration: map['eventDuration'],
      requestAcceptance: map['requestAcceptance'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['id'] = this.id;
    data['userId'] = this.userId;
    data['area'] = this.area;
    data['localAdmin'] = this.localAdmin;
    data['eventDuration'] = this.eventDuration;
    data['requestAcceptance'] = this.requestAcceptance;
    return data;
  }

  Map toStrJson() {
    return {
      "id": this.id,
      "userId": this.userId,
      "area": this.area,
      "localAdmin": this.localAdmin,
      "eventDuration": this.eventDuration,
      "requestAcceptance": this.requestAcceptance,
    };
  }
}
