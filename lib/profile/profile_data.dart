import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'User Profile',
          style: GoogleFonts.beVietnamPro(
            textStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
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
      body: user != null
          ? Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

        ),
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
