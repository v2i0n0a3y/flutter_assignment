import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../profile/profile_data.dart';
import 'ShoppingMode.dart'; // Import your ShoppingModel here

class ProductDetailScreen extends StatefulWidget {
  final ShoppingModel product;
  final Set<ShoppingModel> favoriteList;

  const ProductDetailScreen({Key? key, required this.product, required this.favoriteList}) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    // Initialize `isLiked` based on whether the product is already in the favorite list
    isLiked = widget.favoriteList.contains(widget.product);
  }

  void toggleFavorite() {
    setState(() {
      if (isLiked) {
        widget.favoriteList.remove(widget.product);
      } else {
        widget.favoriteList.add(widget.product);
      }
      isLiked = !isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.product.title ?? 'Product Detail',
          style: GoogleFonts.beVietnamPro(
            textStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.red : Colors.white,
            ),
            onPressed: toggleFavorite,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  widget.product.image.toString(),
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> UserProfileScreen()));
                },
                child: Text(
                  widget.product.title ?? 'No title',
                  style: GoogleFonts.beVietnamPro(
                    textStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Price: \$ ${widget.product.price.toString()}',
                style: GoogleFonts.beVietnamPro(
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Category: ${widget.product.category.toString()}',
                style: GoogleFonts.beVietnamPro(
                  textStyle: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.7)),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Description:',
                style: GoogleFonts.beVietnamPro(
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 5),
              Text(
                widget.product.description ?? 'No description available',
                style: GoogleFonts.beVietnamPro(
                  textStyle: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.6)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
