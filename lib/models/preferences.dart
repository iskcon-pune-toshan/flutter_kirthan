class Preferences {
  final int id;
  String userid;
  String area;
  String localAdmin;
  int eventDuration;
  String requestAcceptance;
  String interestedEventId;

//Typically called form service layer
  Preferences(
      {this.id,
      this.userid,
      this.area,
      this.localAdmin,
      this.eventDuration,
      this.requestAcceptance,
      this.interestedEventId});

//Typically called from the data_source layer after getting data from an external source.
  factory Preferences.fromJson(Map<String, dynamic> data) {
    return Preferences(
      id: data['id'],
      userid: data['userid'],
      area: data['area'],
      localAdmin: data['localAdmin'],
      eventDuration: data['eventDuration'],
      requestAcceptance: data['requestAcceptance'],
      interestedEventId: data['interestedEventId'],
    );
  }

  factory Preferences.fromMap(Map<String, dynamic> map) {
    return Preferences(
      id: map['id'],
      userid: map['userid'],
      area: map['area'],
      localAdmin: map['localAdmin'],
      eventDuration: map['eventDuration'],
      requestAcceptance: map['requestAcceptance'],
      interestedEventId: map['interestedEventId'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['id'] = this.id;
    data['userid'] = this.userid;
    data['area'] = this.area;
    data['localAdmin'] = this.localAdmin;
    data['eventDuration'] = this.eventDuration;
    data['requestAcceptance'] = this.requestAcceptance;
    data['interestedEventId'] = this.interestedEventId;
    return data;
  }

  Map toStrJson() {
    return {
      "id": this.id,
      "userid": this.userid,
      "area": this.area,
      "localAdmin": this.localAdmin,
      "eventDuration": this.eventDuration,
      "requestAcceptance": this.requestAcceptance,
      "interestedEventId": this.interestedEventId,
    };
  }
}
