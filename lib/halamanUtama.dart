import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/halamanKonversiMataUang.dart';
import 'package:weather_app/halamanKonversiWaktu.dart';
import 'package:weather_app/halamanListDaerah.dart';
import 'package:weather_app/halamanProfile.dart';
import 'package:weather_app/model/modelCuaca.dart';
import 'api_data_source.dart';
import 'package:http/http.dart' as http;

class HalamanUtama extends StatefulWidget {
  final String idWilayah;
  final String longitude;
  final String latitude;
  final String kabupaten;
  final String id;

  const HalamanUtama({
    super.key,
    required this.idWilayah,
    required this.longitude,
    required this.latitude,
    required this.kabupaten,
    required this.id,
  });

  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  bool siangHari = false;
  List _listData = [];
  int panjangDB = 0;
  final List<dynamic> _user = List.filled(4, '');

  Future _getuser() async {
    try {
      final response = await http.get(Uri.parse(
          "https://weatherdatabaseaccount.000webhostapp.com/read.php"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _listData = data;
          panjangDB = _listData.length;
          for(int x = 0; x < panjangDB; x++) {
            if(_listData[x]["id"] == widget.id) {
              _user[0] = _listData[x]["idTempat"];
              _user[1] = _listData[x]["tempatDefault"];
              _user[2] = _listData[x]["longitude"];
              _user[3] = _listData[x]["latitute"];
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
                child: FutureBuilder(
                    future: ApiDataSource.instance.getCuaca(widget.idWilayah),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<ModelCuaca> dataCuaca = [];
                        for (var data in snapshot.data!) {
                          ModelCuaca cuaca = ModelCuaca.fromJson(data);
                          dataCuaca.add(cuaca);
                        }
                        List<String?> hari = [
                          "Hari ini",
                          "Hari ini",
                          "Hari ini",
                          "Hari ini",
                          "Besok",
                          "Besok",
                          "Besok",
                          "Besok",
                          "Lusa",
                          "Lusa",
                          "Lusa",
                          "Lusa"
                        ];
                        List<String?> formattedDate = [];
                        int jumlahData = dataCuaca.length;
                        int tampilHari = jumlahData;
                        int indexItem = 0;
                        DateTime waktuSekarang = DateTime.now();
                        int jamSekarang = waktuSekarang.hour;

                        for (int x = 0; x < jumlahData; x += 4) {
                          formattedDate.addAll(
                              List.filled(x + 4 - formattedDate.length, null));
                          formattedDate[x] = formatDate(dataCuaca[x].jamCuaca!);
                        }
                        if (tampilHari >= 12) {
                          tampilHari = 12;
                        }

                        if (jamSekarang < 6) {
                          indexItem = 0;
                        } else if (jamSekarang < 12) {
                          indexItem = 1;
                        } else if (jamSekarang < 18) {
                          indexItem = 2;
                        } else if (jamSekarang < 24) {
                          indexItem = 3;
                        }
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 110,
                            ),
                            Text(
                              "${dataCuaca[0].tempC} C" ?? "NULL",
                              style: const TextStyle(
                                fontSize: 65,
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
                            Image(
                              image: NetworkImage(
                                  "https://ibnux.github.io/BMKG-importer/icon/${dataCuaca[indexItem].kodeCuaca}.png"),
                              width: 80,
                            ),
                            Text(
                              "${dataCuaca[indexItem].cuaca}" ?? "NULL",
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Lat : ${widget.latitude}" ?? "Lat : NULL",
                                  style: const TextStyle(
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
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Lon : ${widget.longitude}" ?? "Lon : NULL",
                                  style: const TextStyle(
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
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 60,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 10, sigmaY: 10),
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.4,
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.5),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Row(
                                              children: [
                                                Image(
                                                  image: AssetImage(
                                                    "assets/ikonKelembaban.png",
                                                  ),
                                                  width: 20,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "Humidity",
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 18),
                                                ),
                                              ],
                                            ),
                                            Expanded(
                                              child: Center(
                                                child: Text(
                                                  "${dataCuaca[indexItem].humidity}" ??
                                                      "NULL",
                                                  style: const TextStyle(
                                                      fontSize: 55,
                                                      color: Colors.black54),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 10, sigmaY: 10),
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.4,
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.5),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Row(
                                              children: [
                                                Image(
                                                  image: AssetImage(
                                                    "assets/ikonSuhu.png",
                                                  ),
                                                  width: 20,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "Temp",
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 18),
                                                ),
                                              ],
                                            ),
                                            Expanded(
                                              child: Center(
                                                child: Text(
                                                  "${dataCuaca[indexItem].tempF} F" ??
                                                      "NULL",
                                                  style: const TextStyle(
                                                      fontSize: 55,
                                                      color: Colors.black54),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.width * 0.05,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        for (int x = 0; x < jumlahData; x += 4)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "${hari[x]}",
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 25,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        "${formattedDate[x]}",
                                                        style: const TextStyle(
                                                            fontSize: 15,
                                                            color:
                                                                Colors.black54),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Text(
                                                          "00.00",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black54,
                                                              fontSize: 20),
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.08,
                                                        ),
                                                        Image(
                                                          image: NetworkImage(
                                                              "https://ibnux.github.io/BMKG-importer/icon/${dataCuaca[x].kodeCuaca}.png"),
                                                          width: 40,
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Text(
                                                          "06.00",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black54,
                                                              fontSize: 20),
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.08,
                                                        ),
                                                        Image(
                                                          image: NetworkImage(
                                                              "https://ibnux.github.io/BMKG-importer/icon/${dataCuaca[x + 1].kodeCuaca}.png"),
                                                          width: 40,
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Text(
                                                          "12.00",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black54,
                                                              fontSize: 20),
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.08,
                                                        ),
                                                        Image(
                                                          image: NetworkImage(
                                                              "https://ibnux.github.io/BMKG-importer/icon/${dataCuaca[x + 2].kodeCuaca}.png"),
                                                          width: 40,
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Text(
                                                          "18.00",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black54,
                                                              fontSize: 20),
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.08,
                                                        ),
                                                        Image(
                                                          image: NetworkImage(
                                                              "https://ibnux.github.io/BMKG-importer/icon/${dataCuaca[x + 3].kodeCuaca}.png"),
                                                          width: 40,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
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
                            SizedBox(
                              height: MediaQuery.of(context).size.width * 0.075,
                            )
                          ],
                        );
                      }
                      return SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: CircularProgressIndicator(),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            ),
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
                    child: InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => HalamanListDaerah(idWilayah: _user[0], longitude: _user[2], latitude: _user[3], kabupaten: _user[1], id: widget.id,)),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(100)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.75,
                            child: Text(
                              widget.kabupaten,
                              style: const TextStyle(
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
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.clip,
                            ),
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
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black54
        ),
        fixedColor: Colors.black54,
        unselectedItemColor: Colors.black26,
        currentIndex: 0,
        onTap: (int index) {
          if (index == 0) {
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (BuildContext context) =>
                    HalamanUtama(idWilayah: _user[0], longitude: _user[2], latitude: _user[3], kabupaten: _user[1], id: widget.id,)));
          }
          // else if (index == 1) {
          //   Navigator.pushReplacement(context, MaterialPageRoute(
          //       builder: (BuildContext context) =>
          //           HalamanWaktu(idWilayah: _user[0], longitude: _user[2], latitude: _user[3], kabupaten: _user[1], id: widget.id,)));
          // }
          // else if (index == 2) {
          //   Navigator.pushReplacement(context, MaterialPageRoute(
          //       builder: (BuildContext context) =>
          //           HalamanMataUang(idWilayah: _user[0], longitude: _user[2], latitude: _user[3], kabupaten: _user[1], id: widget.id,)));
          // }
          else if (index == 3) {
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (BuildContext context) =>
                    HalamanProfile(idWilayah: _user[0], longitude: _user[2], latitude: _user[3], kabupaten: _user[1], id: widget.id,)));
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
}

String formatDate(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  String formattedDate = DateFormat('dd MMMM yyyy').format(dateTime);
  return formattedDate;
}
