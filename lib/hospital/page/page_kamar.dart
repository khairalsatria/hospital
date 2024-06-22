import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../model/model_kamar.dart';

class PageKamar extends StatefulWidget {
  final String idRs;
  final String namaRs;

  const PageKamar({Key? key, required this.idRs, required this.namaRs}) : super(key: key);

  @override
  State<PageKamar> createState() => _PageKamarState();
}

class _PageKamarState extends State<PageKamar> {
  TextEditingController txtCari = TextEditingController();
  List<Datum>? kamarList;
  List<Datum>? filteredKamarList;
  double? latRs;
  double? longRs;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      // Fetch Rumah Sakit data
      final responseRumah = await http.get(Uri.parse('http://192.168.1.3/mobilesmt4/rumahsakit/rumahsakit.php?id_rumah=${widget.idRs}'));
      if (responseRumah.statusCode == 200) {
        final rumahData = jsonDecode(responseRumah.body);
        if (rumahData['data'].isNotEmpty) {
          final rumah = rumahData['data'][0];
          setState(() {
            latRs = double.parse(rumah['lat']);
            longRs = double.parse(rumah['long']);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No Rumah Sakit data available')),
          );
          return;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load Rumah Sakit data')),
        );
        return;
      }

      // Fetch Kamar data
      final responseKamar = await http.get(Uri.parse('http://192.168.1.3/mobilesmt4/rumahsakit/kamar.php?id_rumah=${widget.idRs}'));
      if (responseKamar.statusCode == 200) {
        Modelkamar modelKamar = modelkamarFromJson(responseKamar.body);
        setState(() {
          kamarList = modelKamar.data.where((datum) => datum.idRumah == widget.idRs).toList();
          filteredKamarList = kamarList;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load Kamar data')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void searchKamar(String keyword) {
    setState(() {
      filteredKamarList = kamarList
          ?.where((datum) => datum.namaKamar.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kamar',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: txtCari,
                onChanged: (value) {
                  searchKamar(value);
                },
                decoration: InputDecoration(
                  hintText: "Search",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              SizedBox(height: 20),
              Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Colors.blueGrey,
                child: latRs != null && longRs != null
                    ? Container(
                  height: 300,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(latRs!, longRs!),
                      zoom: 14,
                    ),
                    markers: {
                      Marker(
                        markerId: MarkerId(widget.idRs),
                        position: LatLng(latRs!, longRs!),
                        infoWindow: InfoWindow(title: widget.namaRs),
                      ),
                    },
                  ),
                )
                    : Center(
                  child: Text('No data available'),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'COVID-19',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  Text(
                    'NON COVID-19',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              filteredKamarList == null
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: filteredKamarList?.length ?? 0,
                itemBuilder: (context, index) {
                  Datum? data = filteredKamarList?[index];
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: Image.asset('gambar/rumahsakit2.png', width: 50, height: 50),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data?.namaKamar ?? '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text('Kamar Tersedia : ${data?.tersedia ?? '0'}'),
                                SizedBox(height: 4),
                                Text('Kamar Kosong   : ${data?.tersedia ?? '0'}'),
                                SizedBox(height: 4),
                                Text('Jumlah Antrian : ${data?.antrian ?? '0'}'),
                              ],
                            ),
                            trailing: Icon(Icons.arrow_forward_ios_outlined, size: 15,),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}