
class RoleScreen {
  final int id;
   int roleId;
   int screenId;
  bool createFlag;
  bool updateFlag;
  bool deleteFlag;
  bool viewFlag;
  bool processFlag;
  String roleName;
  String screenName;


//Typically called form service layer
  RoleScreen({this.id, this.roleId, this.screenId, this.createFlag,
    this.updateFlag,
    this.deleteFlag,
    this.viewFlag,
    this.processFlag,
    this.roleName,
    this.screenName,
    });

//Typically called from the data_source layer after getting data from an external source.
  factory RoleScreen.fromJson(Map<String, dynamic> data) {
    return RoleScreen(
      id: data['id'],
      roleId: data['roleId'],
      screenId: data['screenId'],
      createFlag: data['createFlag'],
      updateFlag: data['updateFlag'],
      deleteFlag: data['deleteFlag'],
      viewFlag: data['viewFlag'],
      processFlag: data['processFlag'],
      roleName: data['roleName'],
      screenName: data['screenName'],

    );
  }

  factory RoleScreen.fromMap(Map<String, dynamic> map) {
    return RoleScreen(
      id: map['id'],
      roleId: map['roleId'],
      screenId: map['screenId'],
      createFlag: map['createFlag'],
      updateFlag: map['updateFlag'],
      deleteFlag: map['deleteFlag'],
      viewFlag: map['viewFlag'],
      processFlag: map['processFlag'],
      roleName: map['roleName'],
      screenName: map['screenName']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['roleId'] = this.roleId;
    data['screenId'] = this.screenId;
    data['createFlag'] = this.createFlag;
    data['updateFlag'] = this.updateFlag;
    data['deleteFlag'] = this.deleteFlag;
    data['viewFlag'] = this.viewFlag;
    data['processFlag'] = this.processFlag;
    data['roleName'] = this.roleName;
    data['screenName'] = this.screenName;
       return data;
  }

  Map toStrJson() {
    return {
      "id": this.id,
      "roleId":this.roleId,
      "screenId": this.screenId,
      "createFlag": this.createFlag,
      "updateFlag": this.updateFlag,
      "deleteFlag": this.deleteFlag,
      "viewFlag": this.viewFlag,
      "processFlag": this.processFlag,
      "roleName": this.roleName,
      "screenName": this.screenName
    };
  }

}