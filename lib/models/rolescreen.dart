
class RoleScreen {
  final int id;
   int roleId;
   int screenId;
  bool isCreated;
  bool isUpdated;
  bool isDeleted;
  bool isViewd;
  bool isProcessed;
  String roleName;
  String screenName;


//Typically called form service layer
  RoleScreen({this.id, this.roleId, this.screenId, this.isCreated,
    this.isUpdated,
    this.isDeleted,
    this.isViewd,
    this.isProcessed,
    this.roleName,
    this.screenName,
    });

//Typically called from the data_source layer after getting data from an external source.
  factory RoleScreen.fromJson(Map<String, dynamic> data) {
    return RoleScreen(
      id: data['id'],
      roleId: data['roleId'],
      screenId: data['screenId'],
      isCreated: data['isCreated'],
      isUpdated: data['isUpdated'],
      isDeleted: data['isDeleted'],
      isViewd: data['isViewd'],
      isProcessed: data['isProcessed'],
      roleName: data['roleName'],
      screenName: data['screenName'],

    );
  }

  factory RoleScreen.fromMap(Map<String, dynamic> map) {
    return RoleScreen(
      id: map['id'],
      roleId: map['roleId'],
      screenId: map['screenId'],
      isCreated: map['isCreated'],
      isUpdated: map['isUpdated'],
      isDeleted: map['isDeleted'],
      isViewd: map['isViewd'],
      isProcessed: map['isProcessed'],
      roleName: map['roleName'],
      screenName: map['screenName']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['roleId'] = this.roleId;
    data['screenId'] = this.screenId;
    data['isCreated'] = this.isCreated;
    data['isUpdated'] = this.isUpdated;
    data['isDeleted'] = this.isDeleted;
    data['isViewd'] = this.isViewd;
    data['isProcessed'] = this.isProcessed;
    data['roleName'] = this.roleName;
    data['screenName'] = this.screenName;
       return data;
  }

  Map toStrJson() {
    return {
      "id": this.id,
      "roleId":this.roleId,
      "screenId": this.screenId,
      "isCreated": this.isCreated,
      "isUpdated": this.isUpdated,
      "isUpdated": this.isDeleted,
      "isViewd": this.isViewd,
      "isProcessed": this.isProcessed,
      "roleName": this.roleName,
      "screenName": this.screenName
    };
  }

}