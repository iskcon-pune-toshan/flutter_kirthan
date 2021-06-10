class EventTeam {
  final int id;
  int teamId;
  int eventId;
  String createdBy;
  String createdTime;
  String updatedBy;
  String updatedTime;
  String teamName;
  String eventName;

//Typically called form service layer to create a new user
  EventTeam(
      {this.id,
      this.teamId,
      this.eventId,
      this.createdBy,
      this.updatedBy,
      this.createdTime,
      this.updatedTime,
      this.eventName,
      this.teamName});

//Typically called from the data_source layer after getting data from an external source.
  factory EventTeam.fromJson(Map<String, dynamic> data) {
    return EventTeam(
      id: data['id'],
      teamId: data['teamId'],
      eventId: data['eventId'],
      createdBy: data['createdBy'],
      updatedBy: data['updatedBy'],
      updatedTime: data['updatedTime'],
      createdTime: data['createdTime'],
      eventName: data['eventName'],
      teamName: data['teamName'],
    );
  }

  factory EventTeam.fromMap(Map<String, dynamic> map) {
    return EventTeam(
      id: map['id'],
      teamId: map['teamId'],
      eventId: map['eventId'],
      createdBy: map['createdBy'],
      updatedBy: map['updatedBy'],
      updatedTime: map['updatedTime'],
      createdTime: map['createdTime'],
      eventName: map['eventName'],
      teamName: map['teamName'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['teamId'] = this.teamId;
    data['eventId'] = this.eventId;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    data['updatedTime'] = this.updatedTime;
    data['createdTime'] = this.createdTime;
    data['eventName'] = this.eventName;
    data['teamName'] = this.teamName;

    return data;
  }

  Map toStrJson() {
    return {
      "id": this.id,
      "eventId": this.eventId,
      "teamId": this.teamId,
      "createdBy": this.createdBy,
      "updatedBy": this.updatedBy,
      "updatedTime": this.updatedTime,
      "createdTime": this.createdTime,
      "eventName": this.eventName,
      "teamName": this.teamName
    };
  }
}
