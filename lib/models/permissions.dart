
class Permissions {
  final int id;
  String name;


//Typically called form service layer
  Permissions({this.id, this.name,
  });

//Typically called from the data_source layer after getting data from an external source.
  factory Permissions.fromJson(Map<String, dynamic> data) {
    return Permissions(
        id: data['id'],
        name: data['role_name']

    );
  }

  factory Permissions.fromMap(Map<String, dynamic> map) {
    return Permissions(
      id: map['id'],
      name: map['role_name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['role_name']=this.name;
    return data;
  }

  Map toStrJson() {
    return {
      "id": this.id,
      "role_name":this.name

    };
  }

}