import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'halamanKonversiWaktu.dart';
import 'halamanProfile.dart';
import 'halamanUtama.dart';
import 'package:http/http.dart' as http;

class HalamanMataUang extends StatefulWidget {
  final String idWilayah;
  final String longitude;
  final String latitude;
  final String kabupaten;
  final String id;

  const HalamanMataUang({
    Key? key,
    required this.idWilayah,
    required this.longitude,
    required this.latitude,
    required this.kabupaten,
    required this.id,
  }) : super(key: key);

  @override
  State<HalamanMataUang> createState() => _HalamanMataUangState();
}

class _HalamanMataUangState extends State<HalamanMataUang> {
  bool siangHari = false;
  double _rupiah = 0;
  double _dollar = 0;
  double _ringgit = 0;
  String _currency = "IDR";
  TextEditingController _convertController = TextEditingController();
  List _listData = [];
  int panjangDB = 0;
  List<dynamic> _user = List.filled(4, '');

  @override
  void dispose() {
    _convertController.dispose();
    super.dispose();
  }

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

  void initState() {
    _getuser();
    DateTime waktuSekarang = DateTime.now();
    int jamSekarang = waktuSekarang.hour;
    super.initState();
    if (jamSekarang > 6 && jamSekarang < 18) {
      siangHari = true;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: siangHari
                        ? AssetImage("assets/afternoonSky.jpg")
                        : AssetImage("assets/nightSky.jpg"),
                    fit: BoxFit.cover)),
          ),
          SingleChildScrollView(
            child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 120,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
                            child: Container(
                              width: 350,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  DropdownButton<String>(
                                    icon: Visibility(
                                        visible: false,
                                        child: Icon(Icons.arrow_downward)),
                                    itemHeight: 50,
                                    menuMaxHeight: 50,
                                    focusColor: Colors.black,
                                    value: _currency,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _currency = newValue!;
                                      });
                                    },
                                    items: <String>[
                                      'IDR',
                                      'MYR',
                                      'USD',
                                    ].map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Container(
                                    width: 200,
                                    child: TextFormField(
                                      controller: _convertController,
                                      style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'Jumlah',
                                        hintStyle: TextStyle(
                                          fontSize: 25,
                                          color: Colors.black12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        border: InputBorder.none,
                                        //contentPadding: EdgeInsets.all(10),
                                      ),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [ThousandsFormatter()],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.05,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            convertMoney();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.teal,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.change_circle_rounded,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    "CONVERT",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.05,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
                            child: Container(
                              width: 350,
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical:8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "IDR",
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      width: 200,
                                      child: Text(
                                        "${NumberFormat.decimalPattern().format(_rupiah)}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                          color: Colors.black54
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.05,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
                            child: Container(
                              width: 350,
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical:8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "MYR",
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      width: 200,
                                      child: Text(
                                        "${NumberFormat.decimalPattern().format(_ringgit)}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22,
                                            color: Colors.black54
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.05,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
                            child: Container(
                              width: 350,
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical:8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "USD",
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      width: 200,
                                      child: Text(
                                        "${NumberFormat.decimalPattern().format(_dollar)}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22,
                                            color: Colors.black54
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Positioned(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(100)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(
                              "Konversi Uang",
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
        TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
        fixedColor: Colors.black54,
        unselectedItemColor: Colors.black26,
        currentIndex: 2,
        onTap: (int index) {
          if (index == 0) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => HalamanUtama(
                      idWilayah: _user[0], longitude: _user[2], latitude: _user[3], kabupaten: _user[1], id: widget.id,)));
          } else if (index == 1) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => HalamanWaktu(idWilayah: _user[0], longitude: _user[2], latitude: _user[3], kabupaten: _user[1], id: widget.id,)));
          } else if (index == 2) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => HalamanMataUang(idWilayah: _user[0], longitude: _user[2], latitude: _user[3], kabupaten: _user[1], id: widget.id,)));
          } else if (index == 3) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => HalamanProfile(idWilayah: _user[0], longitude: _user[2], latitude: _user[3], kabupaten: _user[1], id: widget.id,)));
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
  void convertMoney () {
    double jumlah = double.parse(_convertController.text.replaceAll(RegExp(r'[^\d]'), ''));

    if (_currency == "IDR"){
      _rupiah = jumlah;
      _ringgit = jumlah * 0.00030;
      _dollar = jumlah * 0.000064;
    }
    else if (_currency == "MYR"){
      _ringgit = jumlah;
      _rupiah = jumlah * 3320.53;
      _dollar = jumlah * 0.21;
    }
    else if (_currency == "USD"){
      _dollar = jumlah;
      _rupiah = jumlah * 15560;
      _ringgit = jumlah * 4.68;
    }
    setState(() {
      _dollar = _dollar;
      _ringgit = _ringgit;
      _rupiah = _rupiah;
    });
  }
}

class ThousandsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else {
      final int selectionIndexFromTheRight =
          newValue.text.length - newValue.selection.end;
      final String filteredText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
      final List<String> formattedParts = [];
      int currentIndex = filteredText.length;

      while (currentIndex > 3) {
        currentIndex -= 3;
        formattedParts.insert(0, filteredText.substring(currentIndex, currentIndex + 3));
      }

      formattedParts.insert(0, filteredText.substring(0, currentIndex));
      final String result = formattedParts.join(',');
      return TextEditingValue(
        text: result,
        selection: TextSelection.collapsed(
          offset: result.length - selectionIndexFromTheRight,
        ),
      );
    }
  }
}
