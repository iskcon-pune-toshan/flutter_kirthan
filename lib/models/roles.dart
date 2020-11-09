
class Roles {
  final int id;
  String roleName;


//Typically called form service layer
  Roles({this.id, this.roleName,
  });

//Typically called from the data_source layer after getting data from an external source.
  factory Roles.fromJson(Map<String, dynamic> data) {
    return Roles(
      id: data['id'],
      roleName: data['roleName'],

    );
  }

  factory Roles.fromMap(Map<String, dynamic> map) {
    return Roles(
      id: map['id'],
      roleName: map['roleName'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['roleName']=this.roleName;
    return data;
  }

  Map toStrJson() {
    return {
      "id": this.id,
      "roleName":this.roleName,

    };
  }

}