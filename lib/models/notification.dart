//added targetId
class NotificationModel {
  String _uuid;
  String _targetType;
  int _targetId;
  String _message;
  String _action;
  DateTime _createdAt;
  String _createdBy;
  String _updatedBy;
  int _id;

  NotificationModel(
      {DateTime createdAt,
      String createdBy,
      String uuid,
      String message,
      String type,
      int targetId,
      String action,
      int id,
      String updatedBy}) {
    this._targetType = type;
    this._targetId = targetId;
    this._action = action;
    this._createdBy = createdBy;
    this._createdAt = createdAt;
    this._uuid = uuid;
    this._message = message;
    this._id = id;
    this._updatedBy = updatedBy;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data["type"] = this._targetType;
    data["targetId"] = this._targetId;
    data["createdBy"] = this._createdBy;
    data["createdTime"] = this._createdAt;
    data["uuid"] = this._uuid;
    data["action"] = this._action;
    data["message"] = this._message;
    data["id"] = this._id;
    data["updatedBy"] = this._updatedBy;
    return data;
  }

  factory NotificationModel.fromJson(Map<String, dynamic> data) {
    return NotificationModel(
      createdAt: DateTime.parse(data["createdTime"]),
      // == null
      //   ? null
      //   : DateTime.parse(data["createdTime"]),
      createdBy: data["createdBy"],
      uuid: data["uuid"],
      message: data["message"],
      type: data["targetType"],
      action: data["action"],
      id: data["id"],
      updatedBy: data["updatedBy"],
      targetId: data["targetId"],
    );
  }

  String get createdBy => _createdBy;

  String get uuid => _uuid;

  String get targetType => _targetType;

  DateTime get createdAt => _createdAt;

  String get action => _action;

  String get message => _message;

  int get id => _id;

  int get targetId => _targetId;
  String get updatedBy => _updatedBy;
}
