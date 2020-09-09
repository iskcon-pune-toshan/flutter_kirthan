class NotificationModel {
  String _id;
  String _type;
  String _message;
  String _action;
  DateTime _createdAt;
  int _creatorId;

  String get id => _id;

  String get type => _type;

  String get message => _message;

  DateTime get createdAt => _createdAt;

  int get creatorId => _creatorId;

  String get action => _action;
  NotificationModel(
      {DateTime createdAt,
      int creatorId,
      String id,
      String message,
      String type,String action}) {
    this._type = type;
    this._action = action;
    this._creatorId = creatorId;
    this._createdAt = createdAt;
    this._id = id;
    this._message = message;
  }

  Map toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this._type;
    data["creatorId"] = this._creatorId;
    data["createdAt"] = this._createdAt;
    data["id"] = this._id;
    data["action"] = this._action;
    data["message"] = this._message;
  }

  factory NotificationModel.fromJson(Map<String, dynamic> data) {
    return NotificationModel(
        createdAt: DateTime.parse(data["timeOfCreation"]),
        creatorId: data["creatorId"],
        id: data["id"],
        message: data["message"],
        type: data["type"],
        action: data["action"]
    );
  }
}
