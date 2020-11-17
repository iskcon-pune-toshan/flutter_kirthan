class TeamUser {
  final int id;
  int teamId;
  int userId;
  String createdBy;
  String createdTime;
  String updatedBy;
  String updatedTime;
  String teamName;
  String userName;


//Typically called form service layer to create a new user
  TeamUser(
      {this.id,
        this.teamId,
        this.userId,
        this.createdBy,
        this.updatedBy,
        this.createdTime,
        this.updatedTime,
        this.userName,
        this.teamName});

//Typically called from the data_source layer after getting data from an external source.
  factory TeamUser.fromJson(Map<String, dynamic> data) {
    return TeamUser(
      id: data['id'],
      teamId: data['teamId'],
      userId: data['userId'],
      createdBy: data['createdBy'],
      updatedBy: data['updatedBy'],
      updatedTime: data['updatedTime'],
      createdTime: data['createdTime'],
      userName: data['userName'],
      teamName: data['teamName'],
    );
  }

  factory TeamUser.fromMap(Map<String, dynamic> map) {
    return TeamUser(
      id: map['id'],
      teamId: map['teamId'],
      userId: map['userId'],
      createdBy: map['createdBy'],
      updatedBy: map['updatedBy'],
      updatedTime: map['updatedTime'],
      createdTime: map['createdTime'],
      userName: map['userName'],
      teamName: map['teamName'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['teamId'] = this.teamId;
    data['userId'] = this.userId;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    data['updatedTime'] = this.updatedTime;
    data['createdTime'] = this.createdTime;
    data['userName'] = this.userName;
    data['teamName'] = this.teamName;

    return data;
  }

  Map toStrJson() {
    return {
      "id": this.id,
      "userId": this.userId,
      "teamId": this.teamId,
      "createdBy": this.createdBy,
      "updatedBy": this.updatedBy,
      "updatedTime": this.updatedTime,
      "createdTime": this.createdTime,
      "userName": this.userName,
      "teamName": this.teamName
    };
  }
}
