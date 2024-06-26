import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/halamanLogin.dart';

import 'halamanUtama.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String>? items = [];
  bool sudahLogin = false;
  bool isLoading = true; // Menambahkan status loading

  @override
  void initState() {
    cekLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: isLoading
          ? const Center(child: CircularProgressIndicator()) // Widget loading
          : sudahLogin
          ? HalamanUtama(
        idWilayah: items![0],
        longitude: items![1],
        latitude: items![2],
        kabupaten: items![3],
        id: items![4],
      )
          : const HalamanLogin(),
    );
  }

  void cekLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList('items') != null) {
      setState(() {
        items = prefs.getStringList('items');
        sudahLogin = true;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }
}

