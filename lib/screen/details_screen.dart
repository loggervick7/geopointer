import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:geo_locator_app/screen/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utility/local_storage.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  String? email = '';
  String? address = '';
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    email = prefs.getString(SharedKeyConstant.EMAIL_KEY);
    address = prefs.getString(SharedKeyConstant.ADDRESS);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        // on below line we have given title of app
        title: const Text("Details"),
      ),
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Email'),
            Text(email!),
            const Text('Address'),
            Text(address!),
            ElevatedButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                if (context.mounted) {}
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen();
                  },
                ), (route) => false);
              },
              child: const Text('Logout'),
            )
          ],
        ),
      ),
    );
  }
}
