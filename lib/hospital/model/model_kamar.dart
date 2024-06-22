// To parse this JSON data, do
//
//     final modelkamar = modelkamarFromJson(jsonString);

import 'dart:convert';

Modelkamar modelkamarFromJson(String str) => Modelkamar.fromJson(json.decode(str));

String modelkamarToJson(Modelkamar data) => json.encode(data.toJson());

class Modelkamar {
  bool isSuccess;
  String message;
  List<Datum> data;

  Modelkamar({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory Modelkamar.fromJson(Map<String, dynamic> json) => Modelkamar(
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
  String namaKamar;
  String tersedia;
  String kosong;
  String antrian;
  String idRumah;
  String lat;
  String long;

  Datum({
    required this.id,
    required this.namaKamar,
    required this.tersedia,
    required this.kosong,
    required this.antrian,
    required this.idRumah,
    required this.lat,
    required this.long,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    namaKamar: json["nama_kamar"],
    tersedia: json["tersedia"],
    kosong: json["kosong"],
    antrian: json["antrian"],
    idRumah: json["id_rumah"],
    lat: json["lat"],
    long: json["long"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nama_kamar": namaKamar,
    "tersedia": tersedia,
    "kosong": kosong,
    "antrian": antrian,
    "id_rumah": idRumah,
    "lat": lat,
    "long": long,
  };
}
