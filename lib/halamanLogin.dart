import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/halamanRegister.dart';
import 'halamanUtama.dart';
import 'package:crypt/crypt.dart';

class HalamanLogin extends StatefulWidget {

  const HalamanLogin({super.key});

  @override
  State<HalamanLogin> createState() => _HalamanLoginState();
}

class _HalamanLoginState extends State<HalamanLogin> {
  bool isLoginFailed = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  List _listData = [];
  bool siangHari = false;

  Future _getuser() async {
    try {
      final response = await http.get(Uri.parse(
          "https://weatherdatabaseaccount.000webhostapp.com/read.php"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _listData = data;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    _getuser();
    DateTime waktuSekarang = DateTime.now();
    int jamSekarang = waktuSekarang.hour;
    super.initState();
    if (jamSekarang > 6 && jamSekarang < 18) {
      siangHari = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: siangHari
                ? const AssetImage("assets/afternoonSky.jpg")
                : const AssetImage("assets/nightSky.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black,
                      // Atas hitam dengan opasitas 100%
                      Colors.black.withOpacity(0),
                      // Bawah hitam dengan opasitas 50%
                    ],
                  ),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Login untuk melanjutkan",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 10,
                                color: Colors.black,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.025,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaY: 10,
                              sigmaX: 10,
                            ),
                            child: TextFormField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                filled: true,
                                focusColor: Colors.black,
                                fillColor: Colors.white.withOpacity(0.5),
                                hintText: 'Username',
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: 3),
                                    borderRadius: BorderRadius.circular(20)),
                                labelStyle: const TextStyle(
                                    color: Colors.black12, fontSize: 18),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: const BorderSide(
                                    // Mengatur sifat border
                                    color: Colors.blue, // Warna border
                                    width: 2.0, // Ketebalan border
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.width * 0.025),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaY: 10,
                              sigmaX: 10,
                            ),
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                filled: true,
                                focusColor: Colors.black,
                                fillColor: Colors.white.withOpacity(0.5),
                                hintText: 'Password',
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: 3),
                                    borderRadius: BorderRadius.circular(20)),
                                labelStyle: const TextStyle(
                                    color: Colors.black12, fontSize: 18),
                                border: OutlineInputBorder(
                                  // Menambah// kan border
                                  borderRadius: BorderRadius.circular(20.0),
                                  // Mengatur sudut border
                                  borderSide: const BorderSide(
                                    // Mengatur sifat border
                                    color: Colors.blue, // Warna border
                                    width: 2.0, // Ketebalan border
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if(isLoginFailed) (
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.075,
                          child: const Row(
                            children: [
                              Text(
                                "Username / password salah.",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                        )
                        ),
                        if(isLoginFailed==false) (
                            SizedBox(
                                height: MediaQuery.of(context).size.width * 0.075)
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                login();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.teal),
                                child: const Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.login_rounded,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        "LOGIN",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 11.5),
                                  child: Text(
                                    "Belum punya akun?",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 10,
                                          color: Colors.black,
                                          offset: Offset(2, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                HalamanRegister()));
                                  },
                                  child: const Text(
                                    'Register',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        //SizedBox(height: MediaQuery.of(context).size.width * 0.1),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    bool isUserFound = false;

    bool isValid(String cryptFormatHash, String enteredPassword) =>
        Crypt(cryptFormatHash).match(enteredPassword);

    for (int x = 0; x < _listData.length; x++) {
      if (_listData[x]["username"] == username) {
        isUserFound = true;
        bool cekPassword = isValid(_listData[x]["password"], password);
        if (cekPassword) {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setStringList('items', <String>[_listData[x]["idTempat"], _listData[x]["longitude"], _listData[x]["latitute"], _listData[x]["tempatDefault"], _listData[x]["id"]]);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => HalamanUtama(
                idWilayah: _listData[x]["idTempat"],
                longitude: _listData[x]["longitude"],
                latitude: _listData[x]["latitute"],
                kabupaten: _listData[x]["tempatDefault"],
                id: _listData[x]["id"],
              ),
            ),
          );
          break; // Keluar dari loop setelah login berhasil
        }
      }
    }

    if (!isUserFound) {
      setState(() {
        isLoginFailed = true;
      });
    } else {
      setState(() {
        isLoginFailed = true;
      });
    }
  }

}
