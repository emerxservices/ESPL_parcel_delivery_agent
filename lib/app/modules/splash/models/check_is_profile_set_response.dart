import 'dart:convert';

CheckIsProfileSetResponse checkIsProfileSetResponseFromJson(String str) =>
    CheckIsProfileSetResponse.fromJson(json.decode(str));

String checkIsProfileSetResponseToJson(CheckIsProfileSetResponse data) =>
    json.encode(data.toJson());

class CheckIsProfileSetResponse {
  int? status;
  String? message;
  Data? data;

  CheckIsProfileSetResponse({this.status, this.message, this.data});

  CheckIsProfileSetResponse.fromJson(Map<String, dynamic> json) {
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
  bool? diverProfileIsSet;

  Data({this.diverProfileIsSet});

  Data.fromJson(Map<String, dynamic> json) {
    diverProfileIsSet = json['diverProfileIsSet'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['diverProfileIsSet'] = this.diverProfileIsSet;
    return data;
  }
}
