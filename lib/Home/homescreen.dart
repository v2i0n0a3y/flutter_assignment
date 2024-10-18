import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart'as http;
import 'ShoppingMode.dart';
import 'detailedscreen.dart';

class DisplayScreen extends StatefulWidget {
  const DisplayScreen({super.key});

  @override
  State<DisplayScreen> createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {

  User? user;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() {
    // Get the currently signed-in user
    user = FirebaseAuth.instance.currentUser;
    setState(() {}); // Update UI when user data is fetched
  }

  List<ShoppingModel> productList = [];
  Set<ShoppingModel> favoriteList = {}; // Stores favorite products

  Future<List<ShoppingModel>> getJwellaryData() async {
    final response = await http.get(Uri.parse("https://fakestoreapi.com/products"));
    var data = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      for (Map<String, dynamic> index in data) {
        productList.add(ShoppingModel.fromJson(index));
      }
    }
    return productList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(
                user?.displayName ?? 'No username available',
                style: GoogleFonts.beVietnamPro(
                    fontWeight: FontWeight.bold, color: Colors.white),
              ),
              accountEmail: Text(
                user?.email ?? 'No email available',
                style: GoogleFonts.beVietnamPro(
                    fontWeight: FontWeight.w500, color: Colors.white),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: user?.photoURL != null
                    ? NetworkImage(user!.photoURL!)
                    : null,
                child: user?.photoURL == null
                    ? Text(
                  user?.displayName != null
                      ? user!.displayName![0].toUpperCase()
                      : 'U',
                  style: TextStyle(
                      fontSize: 40.0, color: Colors.blueAccent),
                )
                    : null,
              ),
            ),
            ListTile(
              leading: Icon(Icons.heart_broken),
              title: Text('Favourite'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          "Shopping",
          style: GoogleFonts.beVietnamPro(
            textStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: getJwellaryData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                var item = snapshot.data![index];
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      shadowColor: Colors.black,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailScreen(
                                product: item,
                                favoriteList: favoriteList,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          color: Colors.white.withOpacity(.2),
                          height: 120,
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          child: Row(
                            children: [
                              Card(
                                shadowColor: Colors.black,
                                child: Container(
                                  color: Colors.white,
                                  height: 100,
                                  width: 100,
                                  child: item.image.toString().isNotEmpty
                                      ? Image.network(
                                    item.image.toString(),
                                    fit: BoxFit.contain,
                                    height: 30,
                                    width: 30,
                                  )
                                      : Icon(Icons.broken_image, size: 50),
                                ),
                              ),
                              SizedBox(width: 30),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title.toString() ?? 'No description',
                                      style: GoogleFonts.beVietnamPro(
                                        textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      '₹ ${item.price.toString() ?? 'N/A'}',
                                      style: GoogleFonts.beVietnamPro(
                                        textStyle: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '${item.category.toString() ?? 'N/A'}',
                                      style: GoogleFonts.beVietnamPro(
                                        textStyle: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black.withOpacity(.6),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
