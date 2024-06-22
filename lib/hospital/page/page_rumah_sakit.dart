import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hospital/hospital/model/model_rumah_sakit.dart';
import 'package:hospital/hospital/page/page_kamar.dart';
import 'package:http/http.dart' as http;

class PageRumahSakit extends StatefulWidget {
  final String idKabupaten;

  const PageRumahSakit({Key? key, required this.idKabupaten}) : super(key: key);

  @override
  State<PageRumahSakit> createState() => _PageRumahSakitState();
}

class _PageRumahSakitState extends State<PageRumahSakit> {
  bool isLoading = false;
  List<Datum> listRumahSakit = [];
  List<Datum> filteredRumahSakit = [];

  @override
  void initState() {
    super.initState();
    fetchRumahSakitData();
  }

  Future<void> fetchRumahSakitData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse('http://192.168.1.3/mobilesmt4/rumahsakit/rumahsakit.php?id_kabupaten=${widget.idKabupaten}'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          ModelRumahSakit modelRumahSakit = ModelRumahSakit.fromJson(data);
          listRumahSakit = modelRumahSakit.data.where((datum) => datum.idKabupaten == widget.idKabupaten).toList();
          filteredRumahSakit = List.from(listRumahSakit);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void searchRumahSakit(String query) {
    setState(() {
      filteredRumahSakit = listRumahSakit.where((rumahSakit) {
        return rumahSakit.namaRumahSakit.toLowerCase().contains(query.toLowerCase()) ||
            rumahSakit.id.toLowerCase() == query.toLowerCase();
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text('Daftar Rumah Sakit'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: searchRumahSakit,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
                hintText: 'Search Rumah Sakit',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredRumahSakit.length,
              itemBuilder: (context, index) {
                final rumahSakit = filteredRumahSakit[index];
                return Padding(
                  padding: EdgeInsets.all(10),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 5,
                    child: ListTile(
                      leading: Image.network('http://192.168.1.3/mobilesmt4/rumahsakit/gambar/${rumahSakit.gambar}', width: 100, height: 100,),
                      title: Text(
                        rumahSakit.namaRumahSakit,
                        style: TextStyle(
                          color: Colors.cyan,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Alamat    : ${rumahSakit.alamat ?? 'N/A'}'),
                          Text('Deskripsi : ${rumahSakit.deskripsi ?? 'N/A'}'),
                          Text('No Telp   : ${rumahSakit.noTelp ?? 'N/A'}'),
                        ],
                      ),
                      trailing: Icon(Icons.arrow_forward_ios_outlined, size: 15,),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PageKamar(
                              idRs: rumahSakit.id,
                              namaRs: rumahSakit.namaRumahSakit,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}