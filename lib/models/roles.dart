
class Roles {
  final int id;
  String role_name;


//Typically called form service layer
  Roles({this.id, this.role_name,
  });

//Typically called from the data_source layer after getting data from an external source.
  factory Roles.fromJson(Map<String, dynamic> data) {
    return Roles(
      id: data['id'],
      role_name: data['role_name']

    );
  }

  factory Roles.fromMap(Map<String, dynamic> map) {
    return Roles(
      id: map['id'],
      role_name: map['role_name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['role_name']=this.role_name;
    return data;
  }

  Map toStrJson() {
    return {
      "id": this.id,
      "role_name":this.role_name

    };
  }

}