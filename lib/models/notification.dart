class NotificationModel {
  int sourceType;
  int sourceId;
  String message;
  String createdAt;
  NotificationModel(json) {
    sourceType = json['source_type'];
    sourceId = json['source_id'];
    message = json['push_message'];
    createdAt = json['created_at'];
  }
}
