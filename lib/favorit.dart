import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List favoriteMenus = [];

  @override
  void initState() {
    super.initState();
    fetchFavoriteMenus();
  }

  Future<void> fetchFavoriteMenus() async {
    final response = await http.get(Uri.parse(
        'https://mobilecomputing.my.id/api_kania/favorite.php?action=read'));
    if (response.statusCode == 200) {
      setState(() {
        favoriteMenus = json.decode(response.body);
      });
    }
  }

  Future<void> deleteFavoriteMenus(int id) async {
    final response = await http.post(
      Uri.parse(
          'https://mobilecomputing.my.id/api_kania/favorite.php?action=delete'),
      body: {'id': id.toString()},
    );

    if (response.statusCode == 200) {
      fetchFavoriteMenus();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Menu removed from favorites'),
        backgroundColor: Colors.green,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to remove Menu from favorites'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: favoriteMenus.isEmpty
          ? Center(child: Text('Tidak ada data barang elektronik favorit'))
          : ListView.builder(
              itemCount: favoriteMenus.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(10.0),
                  child: ListTile(
                    leading: favoriteMenus[index]['image'] != null
                        ? Image.network(
                            'https://mobilecomputing.my.id/api_kania/${favoriteMenus[index]['image']}',
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
                    title: Text(favoriteMenus[index]['name']),
                    subtitle: Text(
                        'Kategori: ${favoriteMenus[index]['category_name']}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        deleteFavoriteMenus(
                            int.parse(favoriteMenus[index]['id']));
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
