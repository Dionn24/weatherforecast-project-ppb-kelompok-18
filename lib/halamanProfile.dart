import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// import 'halamanKonversiMataUang.dart';
// import 'halamanKonversiWaktu.dart';
import 'halamanLogin.dart';
import 'halamanUtama.dart';

class HalamanProfile extends StatefulWidget {
  final String idWilayah;
  final String longitude;
  final String latitude;
  final String kabupaten;
  final String id;

  const HalamanProfile({
    super.key,
    required this.idWilayah,
    required this.longitude,
    required this.latitude,
    required this.kabupaten,
    required this.id,
  });

  @override
  State<HalamanProfile> createState() => _HalamanProfileState();
}

class _HalamanProfileState extends State<HalamanProfile> {
  bool siangHari = false;
  List _listData = [];
  int panjangDB = 0;
  final List<dynamic> _user = List.filled(9, '');

  Future _getuser() async {
    try {
      final response = await http.get(Uri.parse(
          "https://weatherdatabaseaccount.000webhostapp.com/read.php"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _listData = data;
          panjangDB = _listData.length;
          for (int x = 0; x < panjangDB; x++) {
            if (_listData[x]["id"] == widget.id) {
              _user[0] = _listData[x]["idTempat"];
              _user[1] = _listData[x]["tempatDefault"];
              _user[2] = _listData[x]["longitude"];
              _user[3] = _listData[x]["latitute"];
              _user[4] = _listData[x]["nama"];
              _user[5] = _listData[x]["username"];
              _user[6] = _listData[x]["nim"];
              _user[7] = _listData[x]["kelas"];
              _user[8] = _listData[x]["kesanPesan"];
            }
          }
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
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: siangHari
                        ? const AssetImage("assets/afternoonSky.jpg")
                        : const AssetImage("assets/nightSky.jpg"),
                    fit: BoxFit.cover)),
          ),
          SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.075),
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 120,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(1000),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.25,
                            height: MediaQuery.of(context).size.width * 0.25,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(1000),
                            ),
                            child: Icon(
                              Icons.person_2_rounded,
                              size: MediaQuery.of(context).size.width * 0.1,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          "${_user[4]}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 10,
                                color: Colors.black,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          overflow: TextOverflow.clip,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          "${_user[5]}",
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 18,
                            shadows: [
                              Shadow(
                                blurRadius: 10,
                                color: Colors.black,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          overflow: TextOverflow.clip,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.05,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white.withOpacity(0.5)),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.perm_identity_rounded,
                                    size: 30,
                                    color: Colors.black54,
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "NIM",
                                        style: TextStyle(
                                          color: Colors.black45,
                                          fontSize: 18,
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        child: Text(
                                          "${_user[6]}",
                                          style: const TextStyle(
                                              color: Colors.black54,
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.clip,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.05,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white.withOpacity(0.5)),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.meeting_room_rounded,
                                    size: 30,
                                    color: Colors.black54,
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Kelas",
                                        style: TextStyle(
                                          color: Colors.black45,
                                          fontSize: 18,
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        child: Text(
                                          "${_user[7]}",
                                          style: const TextStyle(
                                              color: Colors.black54,
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.clip,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.05,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white.withOpacity(0.5)),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.place_rounded,
                                    size: 30,
                                    color: Colors.black54,
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Lokasi cuaca default",
                                        style: TextStyle(
                                          color: Colors.black45,
                                          fontSize: 18,
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        child: Text(
                                          "${_user[1]}",
                                          style: const TextStyle(
                                              color: Colors.black54,
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.clip,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.05,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.85,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white.withOpacity(0.5)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Kesan dan Pesan",
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: Text(
                                      _user[8],
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.clip,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              logout();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.red),
                              child: const Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.logout_rounded,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      "LOGOUT",
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
                        ],
                      ),
                    ],
                  ),
                )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Positioned(
                    child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(100)),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          "Profil",
                          style: TextStyle(
                            fontSize: 35,
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
                    ),
                  ),
                )),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        showUnselectedLabels: false,
        selectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
        fixedColor: Colors.black54,
        unselectedItemColor: Colors.black26,
        currentIndex: 3,
        onTap: (int index) {
          if (index == 0) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => HalamanUtama(
                          idWilayah: _user[0],
                          longitude: _user[2],
                          latitude: _user[3],
                          kabupaten: _user[1],
                          id: widget.id,
                        )));
          } else if (index == 1) {
          //   Navigator.pushReplacement(
          //       context,
          //       MaterialPageRoute(
          //           builder: (BuildContext context) => HalamanWaktu(
          //                 idWilayah: _user[0],
          //                 longitude: _user[2],
          //                 latitude: _user[3],
          //                 kabupaten: _user[1],
          //                 id: widget.id,
          //               )));
          // } else if (index == 2) {
          //   Navigator.pushReplacement(
          //       context,
          //       MaterialPageRoute(
          //           builder: (BuildContext context) => HalamanMataUang(
          //                 idWilayah: _user[0],
          //                 longitude: _user[2],
          //                 latitude: _user[3],
          //                 kabupaten: _user[1],
          //                 id: widget.id,
          //               )));
          } else if (index == 3) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => HalamanProfile(
                          idWilayah: _user[0],
                          longitude: _user[2],
                          latitude: _user[3],
                          kabupaten: _user[1],
                          id: widget.id,
                        )));
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_rounded,
              size: 30,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.access_time_filled_rounded,
              size: 30,
            ),
            label: "Time",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.monetization_on_rounded,
              size: 30,
            ),
            label: "Money",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_2_rounded,
              size: 30,
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  void logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('items');
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => const HalamanLogin()));
  }
}
