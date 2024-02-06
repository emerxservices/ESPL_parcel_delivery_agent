import 'dart:convert';

BookingsResponse bookingsResponseFromJson(String str) =>
    BookingsResponse.fromJson(json.decode(str));

String bookingsResponseToJson(BookingsResponse data) =>
    json.encode(data.toJson());

class BookingsResponse {
  int? status;
  String? message;
  Data? data;

  BookingsResponse({this.status, this.message, this.data});

  BookingsResponse.fromJson(Map<String, dynamic> json) {
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
  List<Bookings>? bookings;

  Data({this.totalcount, this.bookings});

  Data.fromJson(Map<String, dynamic> json) {
    totalcount = json['totalcount'];
    if (json['bookings'] != null) {
      bookings = <Bookings>[];
      json['bookings'].forEach((v) {
        bookings!.add(new Bookings.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalcount'] = this.totalcount;
    if (this.bookings != null) {
      data['bookings'] = this.bookings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Bookings {
  int? bookingid;
  String? bookingno;
  String? pickupaddress;
  String? dropaddress;
  int? bookingstatusid;
  String? createdondate;

  Bookings(
      {this.bookingid,
      this.bookingno,
      this.pickupaddress,
      this.dropaddress,
      this.bookingstatusid,
      this.createdondate});

  Bookings.fromJson(Map<String, dynamic> json) {
    bookingid = json['bookingid'];
    bookingno = json['bookingno'];
    pickupaddress = json['pickupaddress'];
    dropaddress = json['dropaddress'];
    bookingstatusid = json['bookingstatusid'];
    createdondate = json['createdondate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookingid'] = this.bookingid;
    data['bookingno'] = this.bookingno;
    data['pickupaddress'] = this.pickupaddress;
    data['dropaddress'] = this.dropaddress;
    data['bookingstatusid'] = this.bookingstatusid;
    data['createdondate'] = this.createdondate;
    return data;
  }
}
