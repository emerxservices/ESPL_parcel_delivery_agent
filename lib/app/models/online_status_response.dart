import 'dart:convert';

OnlineStatusResponse onlineStatusResponseFromJson(String str) =>
    OnlineStatusResponse.fromJson(json.decode(str));

String onlineStatusResponseResponseToJson(OnlineStatusResponse data) =>
    json.encode(data.toJson());

class OnlineStatusResponse {
  int? status;
  String? message;
  Data? data;

  OnlineStatusResponse({this.status, this.message, this.data});

  OnlineStatusResponse.fromJson(Map<String, dynamic> json) {
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
  bool? onduty;

  Data({this.onduty});

  Data.fromJson(Map<String, dynamic> json) {
    onduty = json['onduty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['onduty'] = this.onduty;
    return data;
  }
}
