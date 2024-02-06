import 'dart:convert';

OrderDetailsResponse orderDetailsResponseFromJson(String str) =>
    OrderDetailsResponse.fromJson(json.decode(str));

String orderDetailsResponseToJson(OrderDetailsResponse data) =>
    json.encode(data.toJson());

class OrderDetailsResponse {
  int? status;
  String? message;
  Data? data;

  OrderDetailsResponse({this.status, this.message, this.data});

  OrderDetailsResponse.fromJson(Map<String, dynamic> json) {
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
  int? bookingid;
  String? createdondate;
  String? bookingno;
  double? pickuplat;
  double? pickuplng;
  String? pickupaddress;
  double? droplat;
  double? droplng;
  dynamic driverearning;
  String? instruction;
  String? dropaddress;
  String? pickupname;
  String? pickupcontact;
  dynamic pickupimage;
  String? recipientname;
  String? recipientcontact;
  String? paymentstatus;
  String? bookingstatus;
  String? parceltypetitle;
  String? parceltypedesc;
  String? weightslot;
  String? pickupdistance;
  String? dropdistance;
  String? totaltripdistance;

  Data(
      {this.bookingid,
      this.createdondate,
      this.bookingno,
      this.pickuplat,
      this.pickuplng,
      this.pickupaddress,
      this.droplat,
      this.droplng,
      this.driverearning,
      this.instruction,
      this.dropaddress,
      this.pickupname,
      this.pickupcontact,
      this.pickupimage,
      this.recipientname,
      this.recipientcontact,
      this.paymentstatus,
      this.bookingstatus,
      this.parceltypetitle,
      this.parceltypedesc,
      this.weightslot,
      this.pickupdistance,
      this.dropdistance,
      this.totaltripdistance});

  Data.fromJson(Map<String, dynamic> json) {
    bookingid = json['bookingid'];
    createdondate = json['createdondate'];
    bookingno = json['bookingno'];
    pickuplat = json['pickuplat'];
    pickuplng = json['pickuplng'];
    pickupaddress = json['pickupaddress'];
    droplat = json['droplat'];
    droplng = json['droplng'];
    driverearning = json['driverearning'];
    instruction = json['instruction'];
    dropaddress = json['dropaddress'];
    pickupname = json['pickupname'];
    pickupcontact = json['pickupcontact'];
    pickupimage = json['pickupimage'];
    recipientname = json['recipientname'];
    recipientcontact = json['recipientcontact'];
    paymentstatus = json['paymentstatus'];
    bookingstatus = json['bookingstatus'];
    parceltypetitle = json['parceltypetitle'];
    parceltypedesc = json['parceltypedesc'];
    weightslot = json['weightslot'];
    pickupdistance = json['pickupdistance'];
    dropdistance = json['dropdistance'];
    totaltripdistance = json['totaltripdistance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookingid'] = this.bookingid;
    data['createdondate'] = this.createdondate;
    data['bookingno'] = this.bookingno;
    data['pickuplat'] = this.pickuplat;
    data['pickuplng'] = this.pickuplng;
    data['pickupaddress'] = this.pickupaddress;
    data['droplat'] = this.droplat;
    data['droplng'] = this.droplng;
    data['driverearning'] = this.driverearning;
    data['instruction'] = this.instruction;
    data['dropaddress'] = this.dropaddress;
    data['pickupname'] = this.pickupname;
    data['pickupcontact'] = this.pickupcontact;
    data['pickupimage'] = this.pickupimage;
    data['recipientname'] = this.recipientname;
    data['recipientcontact'] = this.recipientcontact;
    data['paymentstatus'] = this.paymentstatus;
    data['bookingstatus'] = this.bookingstatus;
    data['parceltypetitle'] = this.parceltypetitle;
    data['parceltypedesc'] = this.parceltypedesc;
    data['weightslot'] = this.weightslot;
    data['pickupdistance'] = this.pickupdistance;
    data['dropdistance'] = this.dropdistance;
    data['totaltripdistance'] = this.totaltripdistance;
    return data;
  }
}
