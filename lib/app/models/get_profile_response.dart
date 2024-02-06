import 'dart:convert';

GetProfileResponse getProfileResponseFromJson(String str) =>
    GetProfileResponse.fromJson(json.decode(str));

String getProfileResponseToJson(GetProfileResponse data) =>
    json.encode(data.toJson());

class GetProfileResponse {
  int? status;
  String? message;
  Data? data;

  GetProfileResponse({this.status, this.message, this.data});

  GetProfileResponse.fromJson(Map<String, dynamic> json) {
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
  int? driverid;
  String? firstname;
  String? lastname;
  String? countrycode;
  String? phone;
  String? email;
  bool? isapproved;
  String? driverimagename;
  String? driverimagepath;
  dynamic vehicleno;
  dynamic licenseno;
  dynamic licenseexpirydate;
  dynamic licenceimagename;
  dynamic licenceimagepath;

  Data(
      {this.driverid,
      this.firstname,
      this.lastname,
      this.countrycode,
      this.phone,
      this.email,
      this.isapproved,
      this.driverimagename,
      this.driverimagepath,
      this.vehicleno,
      this.licenseno,
      this.licenseexpirydate,
      this.licenceimagename,
      this.licenceimagepath});

  Data.fromJson(Map<String, dynamic> json) {
    driverid = json['driverid'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    countrycode = json['countrycode'];
    phone = json['phone'];
    email = json['email'];
    isapproved = json['isapproved'];
    driverimagename = json['driverimagename'];
    driverimagepath = json['driverimagepath'];
    vehicleno = json['vehicleno'];
    licenseno = json['licenseno'];
    licenseexpirydate = json['licenseexpirydate'];
    licenceimagename = json['licenceimagename'];
    licenceimagepath = json['licenceimagepath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['driverid'] = this.driverid;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['countrycode'] = this.countrycode;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['isapproved'] = this.isapproved;
    data['driverimagename'] = this.driverimagename;
    data['driverimagepath'] = this.driverimagepath;
    data['vehicleno'] = this.vehicleno;
    data['licenseno'] = this.licenseno;
    data['licenseexpirydate'] = this.licenseexpirydate;
    data['licenceimagename'] = this.licenceimagename;
    data['licenceimagepath'] = this.licenceimagepath;
    return data;
  }
}
