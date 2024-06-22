// To parse this JSON data, do
//
//     final modelRumahSakit = modelRumahSakitFromJson(jsonString);

import 'dart:convert';

ModelRumahSakit modelRumahSakitFromJson(String str) => ModelRumahSakit.fromJson(json.decode(str));

String modelRumahSakitToJson(ModelRumahSakit data) => json.encode(data.toJson());

class ModelRumahSakit {
  bool isSuccess;
  String message;
  List<Datum> data;

  ModelRumahSakit({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory ModelRumahSakit.fromJson(Map<String, dynamic> json) => ModelRumahSakit(
    isSuccess: json["isSuccess"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String id;
  String idKabupaten;
  String namaRumahSakit;
  String deskripsi;
  String gambar;
  String alamat;
  String noTelp;
  String lat;
  String long;

  Datum({
    required this.id,
    required this.idKabupaten,
    required this.namaRumahSakit,
    required this.deskripsi,
    required this.gambar,
    required this.alamat,
    required this.noTelp,
    required this.lat,
    required this.long,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    idKabupaten: json["id_kabupaten"],
    namaRumahSakit: json["nama_rumah_sakit"],
    deskripsi: json["deskripsi"],
    gambar: json["gambar"],
    alamat: json["alamat"],
    noTelp: json["no_telp"],
    lat: json["lat"],
    long: json["long"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "id_kabupaten": idKabupaten,
    "nama_rumah_sakit": namaRumahSakit,
    "deskripsi": deskripsi,
    "gambar": gambar,
    "alamat": alamat,
    "no_telp": noTelp,
    "lat": lat,
    "long": long,
  };
}
