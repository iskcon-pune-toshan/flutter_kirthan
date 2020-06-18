class EventUser {
  final int id;
  int eventId;
  int teamId;
  int userId;
  String createdBy;
  String createTime;
  String updatedBy;
  String updateTime;
  String teamName;
  String userName;
  String eventName;


//Typically called form service layer to create a new user
  EventUser(
      {this.id,
        this.eventId,
      this.teamId,
      this.userId,
      this.createdBy,
      this.updatedBy,
      this.createTime,
      this.updateTime,
      this.teamName,
      this.userName,
      this.eventName});

//Typically called from the data_source layer after getting data from an external source.
  factory EventUser.fromJson(Map<String, dynamic> data) {
    return EventUser(
      id: data['id'],
      eventId: data['eventId'],
      teamId: data['teamId'],
      userId: data['userId'],
      createdBy: data['createdBy'],
      updatedBy: data['updatedBy'],
      updateTime: data['updateTime'],
      createTime: data['createTime'],
      teamName: data['teamName'],
      userName: data['userName'],
      eventName: data['eventName'],
    );
  }

  factory EventUser.fromMap(Map<String, dynamic> map) {
    return EventUser(
      id: map['id'],
      eventId: map['eventId'],
      teamId: map['teamId'],
      userId: map['userId'],
      createdBy: map['createdBy'],
      updatedBy: map['updatedBy'],
      updateTime: map['updateTime'],
      createTime: map['createTime'],
      teamName: map['teamName'],
      userName: map['userName'],
      eventName: map['eventName'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['eventId'] = this.eventId;
    data['teamId'] = this.teamId;
    data['userId'] = this.userId;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    data['updateTime'] = this.updateTime;
    data['createTime'] = this.createTime;
    data['teamName'] = this.teamName;
    data['userName'] = this.userName;
    data['eventName'] = this.eventName;
    return data;
  }

  Map toStrJson() {
    return {
      "id": this.id,
      "eventId": this.eventId,
      "userId": this.userId,
      "teamId": this.teamId,
      "createdBy": this.createdBy,
      "updatedBy": this.updatedBy,
      "updateTime": this.updateTime,
      "createTime": this.createTime,
      "teamName": this.teamName,
      "userName": this.userName,
      "eventName": this.eventName,
    };
  }
}
