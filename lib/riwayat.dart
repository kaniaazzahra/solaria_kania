import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RiwayatPage extends StatefulWidget {
  @override
  _RiwayatPageState createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  List riwayatOrders = [];

  @override
  void initState() {
    super.initState();
    fetchRiwayatOrders();
  }

  Future<void> fetchRiwayatOrders() async {
    final response = await http.get(Uri.parse(
        'https://mobilecomputing.my.id/api_kania/riwayat.php?action=read'));
    if (response.statusCode == 200) {
      setState(() {
        riwayatOrders = json.decode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: riwayatOrders.isEmpty
          ? Center(child: Text('Tidak ada data riwayat orders'))
          : ListView.builder(
              itemCount: riwayatOrders.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(10.0),
                  child: ListTile(
                    leading: riwayatOrders[index]['image'] != null
                        ? Image.network(
                            'https://mobilecomputing.my.id/api_kania/${riwayatOrders[index]['image']}',
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/logo.png',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                    title: Text(riwayatOrders[index]['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Kategori: ${riwayatOrders[index]['category_name']}'),
                        Text('Subtotal: ${riwayatOrders[index]['subtotal']}'),
                        Text('Quantity: ${riwayatOrders[index]['quantity']}'),
                        Text('Date: ${riwayatOrders[index]['date']}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
