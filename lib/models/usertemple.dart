
class UserTemple {
  final int id;
  int templeId;
   int roleId;
   int userId;
   String templeName;
   String userName;


//Typically called form service layer
  UserTemple({this.id, this.userId,this.roleId,this.templeId,this.templeName,this.userName
    });

//Typically called from the data_source layer after getting data from an external source.
  factory UserTemple.fromJson(Map<String, dynamic> data) {
    return UserTemple(
      id: data['id'],
      roleId: data['roleId'],
      userId: data['userId'],
      templeId: data['templeId'],
      templeName: data['templeName'],
      userName: data['userName']
    );
  }

  factory UserTemple.fromMap(Map<String, dynamic> map) {
    return UserTemple(
      id: map['id'],
        roleId: map['roleId'],
        userId: map['userId'],
        templeId: map['templeId'],
        templeName: map['templeName'],
        userName: map['userName']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['roleId'] = this.roleId;
    data['userId'] = this.userId;
    data['templeId'] = this.templeId;
    data['templeName'] = this.templeName;
    data['userName'] = this.userName;
       return data;
  }

  Map toStrJson() {
    return {
      "id": this.id,
      "roleId": this.roleId,
      "userId": this.userId,
      "templeId": this.templeId,
      "templeName" : this.templeName,
      "userName" : this.userName
    };
  }

}