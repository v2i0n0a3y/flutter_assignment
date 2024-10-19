import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart'as http;
import '../profile/firebase_profile_screen.dart';
import 'ShoppingMode.dart';
import 'detailedscreen.dart';
import 'favourite_prosucts.dart';

class DisplayScreen extends StatefulWidget {
  const DisplayScreen({super.key});

  @override
  State<DisplayScreen> createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  User? user;
  List<ShoppingModel> productList = [];
  List<ShoppingModel> filteredProductList = []; // For filtered search results
  Set<ShoppingModel> favoriteList = {}; // Stores favorite products
  TextEditingController searchController = TextEditingController(); // Search controller

  @override
  void initState() {
    super.initState();
    getUserData();
    getJwellaryData(); // Fetch data when screen is initialized
  }

  void getUserData() {
    user = FirebaseAuth.instance.currentUser;
    setState(() {});
  }

  Future<List<ShoppingModel>> getJwellaryData() async {
    final response = await http.get(Uri.parse("https://fakestoreapi.com/products"));
    var data = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      productList = data.map<ShoppingModel>((json) => ShoppingModel.fromJson(json)).toList();

      // Apply filtering to exclude specific products
      productList = productList.where((product) {
        // Exclude products based on a specific condition
        // Example conditions (you can modify as per your requirement):
        return product.id != 14 || product.category != 'electronics' && product.title != 'Some Product Name';
      }).toList();

      filteredProductList = productList; // Set filtered products
      setState(() {}); // Update the UI with the filtered list
    }
    return productList;
  }


  // Function to filter the product list based on search input
  void filterProducts(String query) {
    List<ShoppingModel> results = [];
    if (query.isEmpty) {
      results = productList;
    } else {
      results = productList.where((item) => item.title!.toLowerCase().contains(query.toLowerCase())).toList();
    }

    setState(() {
      filteredProductList = results;
    });
  }

  @override
  void dispose() {
    searchController.dispose(); // Clean up controller when widget is removed
    super.dispose();
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
              currentAccountPicture: InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen()));
                },
                child: CircleAvatar(
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

            ),
            ListTile(
              leading: Icon(Icons.heart_broken),
              title: Text('Favourite', style: GoogleFonts.beVietnamPro(
                textStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black.withOpacity(.5)),
              ),),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FavoritesScreen(favoriteList: favoriteList),
                  ),
                );
                           },
            ),
            Divider(color: Colors.black.withOpacity(.2),),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile',   style: GoogleFonts.beVietnamPro(
                textStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black.withOpacity(.5)),
              ),),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen()));
              },
            ),
            Divider(color: Colors.black.withOpacity(.2),),

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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) => filterProducts(value), // Call filter function on text input
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: filteredProductList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: filteredProductList.length,
        itemBuilder: (context, index) {
          var item = filteredProductList[index];
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
                                '\$ ${item.price.toString() ?? 'N/A'}',
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
      ),
    );
  }
}
