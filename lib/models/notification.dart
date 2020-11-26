class NotificationModel {
  String _uuid;
  String _targetType;
  String _message;
  String _action;
  DateTime _createdAt;
  String _createdBy;

  NotificationModel(
      {DateTime createdAt,
      String createdBy,
      String id,
      String message,
      String type,
      String action}) {
    this._targetType = type;
    this._action = action;
    this._createdBy = createdBy;
    this._createdAt = createdAt;
    this._uuid = id;
    this._message = message;
  }

  Map toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this._targetType;
    data["createdBy"] = this._createdBy;
    data["createdTime"] = this._createdAt;
    data["uuid"] = this._uuid;
    data["action"] = this._action;
    data["message"] = this._message;
  }

  factory NotificationModel.fromJson(Map<String, dynamic> data) {
    return NotificationModel(
        createdAt: data["createdTime"] == null
            ? null
            : DateTime.parse(data["createdTime"]),
        createdBy: (data["createdBy"]),
        id: data["uuid"],
        message: data["message"],
        type: data["targetType"],
        action: data["action"]);
  }

  String get createdBy => _createdBy;

  String get uuid => _uuid;

  String get targetType => _targetType;

  DateTime get createdAt => _createdAt;

  String get action => _action;

  String get message => _message;
}
