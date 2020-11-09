
class RoleScreen {
  final int id;
   int role_id;
   int screen_id;
  bool create;
  bool update;
  bool delete;
  bool view;
  bool process;


//Typically called form service layer
  RoleScreen({this.id, this.role_id, this.screen_id, this.create,
    this.update,
    this.delete,
    this.view,
    this.process,
    });

//Typically called from the data_source layer after getting data from an external source.
  factory RoleScreen.fromJson(Map<String, dynamic> data) {
    return RoleScreen(
      id: data['id'],
      role_id: data['role_id'],
      screen_id: data['screen_id'],
      create: data['create'],
      update: data['update'],
      delete: data['delete'],
      view: data['view'],
      process: data['process'],

    );
  }

  factory RoleScreen.fromMap(Map<String, dynamic> map) {
    return RoleScreen(
      id: map['id'],
      role_id: map['role_id'],
      screen_id: map['screnn_id'],
      create: map['create'],
      update: map['update'],
      delete: map['delete'],
      view: map['view'],
      process: map['process'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['role_id'] = this.role_id;
    data['screen_id'] = this.screen_id;
    data['create'] = this.create;
    data['update'] = this.update;
    data['delete'] = this.delete;
    data['view'] = this.view;
    data['process'] = this.process;
       return data;
  }

  Map toStrJson() {
    return {
      "id": this.id,
      "role_id":this.role_id,
      "screen_id": this.screen_id,
      "create": this.create,
      "update": this.update,
      "delete": this.delete,
      "view": this.view,
      "process": this.process,
    };
  }

}