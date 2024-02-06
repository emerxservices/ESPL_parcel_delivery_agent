import 'dart:convert';

EarningResponse earningResponseFromJson(String str) => EarningResponse.fromJson(json.decode(str));

String earningResponseToJson(EarningResponse data) => json.encode(data.toJson());

class EarningResponse {
  int? status;
  String? message;
  Data? data;

  EarningResponse({this.status, this.message, this.data});

  EarningResponse.fromJson(Map<String, dynamic> json) {
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
  List<AllEarnings>? allEarnings;
  String? sum;

  Data({this.allEarnings, this.sum});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['allEarnings'] != null) {
      allEarnings = <AllEarnings>[];
      json['allEarnings'].forEach((v) {
        allEarnings!.add(new AllEarnings.fromJson(v));
      });
    }
    sum = json['sum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.allEarnings != null) {
      data['allEarnings'] = this.allEarnings!.map((v) => v.toJson()).toList();
    }
    data['sum'] = this.sum;
    return data;
  }
}

class AllEarnings {
  String? bookingdate;
  String? bookingno;
  double? earnings;

  AllEarnings({this.bookingdate, this.bookingno, this.earnings});

  AllEarnings.fromJson(Map<String, dynamic> json) {
    bookingdate = json['bookingdate'];
    bookingno = json['bookingno'];
    earnings = json['earnings'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookingdate'] = this.bookingdate;
    data['bookingno'] = this.bookingno;
    data['earnings'] = this.earnings;
    return data;
  }
}
