import 'dart:convert';

EmptyResponse emptyResponseFromJson(String str) =>
    EmptyResponse.fromJson(json.decode(str));

String emptyResponseToJson(EmptyResponse data) => json.encode(data.toJson());

class EmptyResponse {
  int? status;
  String? message;
  Data? data;

  EmptyResponse({this.status, this.message, this.data});

  EmptyResponse.fromJson(Map<String, dynamic> json) {
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
  Data();

  Data.fromJson(Map<String, dynamic> json) {}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}
