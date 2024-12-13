import 'package:aqua/pages/Navigator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _email;
  String? _phoneNumber;
  String? _username;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      User? _currentUser = _auth.currentUser;
      if (_currentUser != null) {
        DocumentSnapshot snapshot = await _firestore.collection('users').doc(_currentUser.uid).get();

        if (snapshot.exists) {
          setState(() {
            _email = _currentUser.email;
            _phoneNumber = snapshot.get('Phone');
            _username = snapshot.get('Username');
          });
        } else {
          print('User data does not exist');
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    } finally {
      setState(() {
        _isLoading = false; // Stop loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Get.offAll(const MyNavigationBar());
          },
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(10.0),
          child: Container(
            color: Colors.white,
            height: 0,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.blue, Colors.grey]),
          ),
        ),
        centerTitle: false,
        title: const Text(
          "Profile",
          style: TextStyle(fontFamily: "roboto", color: Colors.white),
        ),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator(
          color: Colors.blue,
        ) // Show loading indicator while data is being fetched
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blueGrey,
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              _buildUserInfoContainer("Email", _email),
              const SizedBox(height: 20),
              _buildUserInfoContainer("Phone Number", _phoneNumber),
              const SizedBox(height: 20),
              _buildUserInfoContainer("Username", _username),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoContainer(String label, String? value) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A', // Show 'N/A' if the value is null
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
