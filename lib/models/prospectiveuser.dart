//added service type (Free / Premium )
class ProspectiveUserRequest {
  final int id;
  String userEmail;
  String localAdminEmail;
  String inviteType;
  String inviteCode;
  bool isProcessed;

//Typically called form service layer to create a new user
  ProspectiveUserRequest({
    this.id,
    this.userEmail,
    this.localAdminEmail,
    this.inviteCode,
    this.inviteType,
    this.isProcessed,
  });

//Typically called from the data_source layer after getting data from an external source.
  factory ProspectiveUserRequest.fromJson(Map<String, dynamic> data) {
    return ProspectiveUserRequest(
      id: data['id'],
      userEmail: data['userEmail'],
      localAdminEmail: data['localAdminEmail'],
      inviteCode: data['inviteCode'],
      inviteType: data['inviteType'],
      isProcessed: data['isProcessed'],
    );
  }

  factory ProspectiveUserRequest.fromMap(Map<String, dynamic> map) {
    return ProspectiveUserRequest(
      id: map['id'],
      userEmail: map['userEmail'],
      localAdminEmail: map['localAdminEmail'],
      inviteType: map['inviteType'],
      inviteCode: map['inviteCode'],
      isProcessed: map['isProcessed'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userEmail'] = this.userEmail;
    data['localAdminEmail'] = this.localAdminEmail;
    data['inviteType'] = this.inviteType;
    data['inviteCode'] = this.inviteCode;
    data['isProcessed'] = this.isProcessed;
    return data;
  }

  Map toStrJson() {
    return {
      "id": this.id,
      "userEmail": this.userEmail,
      "localAdminEmail": this.localAdminEmail,
      "inviteType": this.inviteType,
      "inviteCode": this.inviteCode,
      "isProcessed": this.isProcessed,
    };
  }
}
