
class TeamRequest {
  final int id;
  String teamTitle;
  String teamDescription;
  bool isProcessed;
  String createdBy;
  String createdTime;
  String updatedBy;
  String updatedTime;
  String approvalStatus;
  String approvalComments;


//Typically called form service layer to create a new user
  TeamRequest({this.id, this.teamTitle, this.teamDescription, this.isProcessed,
    this.createdBy,
    this.updatedBy,
    this.createdTime,
    this.updatedTime,
    this.approvalStatus,
    this.approvalComments });

//Typically called from the data_source layer after getting data from an external source.
  factory TeamRequest.fromJson(Map<String, dynamic> data) {
    return TeamRequest(
      id: data['id'],
      teamTitle: data['teamTitle'],
      teamDescription: data['teamDescription'],
      isProcessed: data['isProcessed'],
      createdBy: data['createdBy'],
      updatedBy: data['updatedBy'],
      updatedTime: data['updatedTime'],
      createdTime: data['createdTime'],
      approvalStatus: data['approvalStatus'],
      approvalComments: data['approvalComments'],
    );
  }

  factory TeamRequest.fromMap(Map<String, dynamic> map) {
    return TeamRequest(
      id: map['id'],
      teamTitle: map['teamTitle'],
      teamDescription: map['teamDescription'],
      isProcessed: map['isProcessed'],
      createdBy: map['createdBy'],
      updatedBy: map['updatedBy'],
      updatedTime: map['updatedTime'],
      createdTime: map['createdTime'],
      approvalStatus: map['approvalStatus'],
      approvalComments: map['approvalComments'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['teamTitle'] = this.teamTitle;
    data['teamDescription'] = this.teamDescription;
    data['isProcessed'] = this.isProcessed;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    data['updatedTime'] = this.updatedTime;
    data['createdTime'] = this.createdTime;
    data['approvalStatus'] = this.approvalStatus;
    data['approvalComments'] = this.approvalComments;

    return data;
  }

  Map toStrJson() {
    return {
      "id": this.id,

      "teamDescription": this.teamDescription,

      "teamTitle": this.teamTitle,

      "isProcessed": this.isProcessed,
      "createdBy": this.createdBy,
      "updatedBy": this.updatedBy,
      "updatedTime": this.updatedTime,
      "createdTime": this.createdTime,
      "approvalStatus": this.approvalStatus,
      "approvalComments": this.approvalComments
    };
  }

}