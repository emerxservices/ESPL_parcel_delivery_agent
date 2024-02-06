import 'dart:convert';

NotificationResponse notificationResponseFromJson(String str) =>
    NotificationResponse.fromJson(json.decode(str));

String notificationResponseToJson(NotificationResponse data) =>
    json.encode(data.toJson());

class NotificationResponse {
  int? status;
  String? message;
  Data? data;

  NotificationResponse({this.status, this.message, this.data});

  NotificationResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? totalcount;
  List<Notifications>? notifications;

  Data({this.totalcount, this.notifications});

  Data.fromJson(Map<String, dynamic> json) {
    totalcount = json['totalcount'];
    if (json['notifications'] != null) {
      notifications = <Notifications>[];
      json['notifications'].forEach((v) {
        notifications!.add(new Notifications.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalcount'] = this.totalcount;
    if (this.notifications != null) {
      data['notifications'] =
          this.notifications!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Notifications {
  int? notificationid;
  String? notificationtitle;
  String? notificationbody;
  String? createdondate;

  Notifications(
      {this.notificationid,
      this.notificationtitle,
      this.notificationbody,
      this.createdondate});

  Notifications.fromJson(Map<String, dynamic> json) {
    notificationid = json['notificationid'];
    notificationtitle = json['notificationtitle'];
    notificationbody = json['notificationbody'];
    createdondate = json['createdondate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notificationid'] = this.notificationid;
    data['notificationtitle'] = this.notificationtitle;
    data['notificationbody'] = this.notificationbody;
    data['createdondate'] = this.createdondate;
    return data;
  }
}
