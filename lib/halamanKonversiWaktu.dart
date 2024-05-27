import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'halamanKonversiMataUang.dart';
import 'halamanProfile.dart';
import 'halamanUtama.dart';

class HalamanWaktu extends StatefulWidget {
  final String idWilayah;
  final String longitude;
  final String latitude;
  final String kabupaten;
  final String id;

  const HalamanWaktu({
    Key? key,
    required this.idWilayah,
    required this.longitude,
    required this.latitude,
    required this.kabupaten,
    required this.id,
  }) : super(key: key);

  @override
  State<HalamanWaktu> createState() => _HalamanWaktuState();
}

class _HalamanWaktuState extends State<HalamanWaktu> {
  bool siangHari = false;
  String _selectedItemHour = '00';
  String _selectedItemMinute = '00';
  String _selectedTime = 'WITA';
  String _minuteConvert = '00';
  String _WITTime = "01";
  String _WITATime = "00";
  String _WIBTime = "23";
  String _GMTTime = "16";
  List<String> waktuJam = [
    '00',
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
  ];
  List<String> waktuMenit = [
    '00',
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
    '30',
    '31',
    '32',
    '33',
    '34',
    '35',
    '36',
    '37',
    '38',
    '39',
    '40',
    '41',
    '42',
    '43',
    '44',
    '45',
    '46',
    '47',
    '48',
    '49',
    '50',
    '51',
    '52',
    '53',
    '54',
    '55',
    '56',
    '57',
    '58',
    '59'
  ];
  List _listData = [];
  int panjangDB = 0;
  List<dynamic> _user = List.filled(4, '');

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
            child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.075),
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 120,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            width: 350,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                DropdownButton<String>(
                                  icon: Visibility(
                                      visible: false,
                                      child: Icon(Icons.arrow_downward)),
                                  itemHeight: 100,
                                  menuMaxHeight: 100,
                                  focusColor: Colors.black,
                                  value: _selectedItemHour,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedItemHour = newValue!;
                                    });
                                  },
                                  items: waktuJam.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 50,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                Text(
                                  ".",
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold),
                                ),
                                DropdownButton<String>(
                                  icon: Visibility(
                                      visible: false,
                                      child: Icon(Icons.arrow_downward)),
                                  itemHeight: 100,
                                  menuMaxHeight: 100,
                                  focusColor: Colors.black,
                                  value: _selectedItemMinute,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedItemMinute = newValue!;
                                    });
                                  },
                                  items: waktuMenit.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 50,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                Text(
                                  " ",
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold),
                                ),
                                DropdownButton<String>(
                                  icon: Visibility(
                                      visible: false,
                                      child: Icon(Icons.arrow_downward)),
                                  itemHeight: 100,
                                  menuMaxHeight: 100,
                                  focusColor: Colors.black,
                                  value: _selectedTime,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedTime = newValue!;
                                    });
                                  },
                                  items: <String>[
                                    'WIT',
                                    'WITA',
                                    'WIB',
                                    "GMT",
                                  ].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 45,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.05,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              convertTime();
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
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                height: MediaQuery.of(context).size.width * 0.4,
                                width: MediaQuery.of(context).size.width * 0.4,
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "WIT",
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 18),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "${_WITTime}" ?? "NULL",
                                                style: TextStyle(
                                                    fontSize: 45,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black54),
                                              ),
                                              Text(
                                                "." ?? "NULL",
                                                style: TextStyle(
                                                    fontSize: 45,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black54),
                                              ),
                                              Text(
                                                "${_minuteConvert}" ?? "NULL",
                                                style: TextStyle(
                                                    fontSize: 45,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black54),
                                              ),
                                            ],
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
                            width: MediaQuery.of(context).size.width * 0.05,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                height: MediaQuery.of(context).size.width * 0.4,
                                width: MediaQuery.of(context).size.width * 0.4,
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "WITA",
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 18),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "${_WITATime}" ?? "NULL",
                                                style: TextStyle(
                                                    fontSize: 45,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black54),
                                              ),
                                              Text(
                                                "." ?? "NULL",
                                                style: TextStyle(
                                                    fontSize: 45,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black54),
                                              ),
                                              Text(
                                                "${_minuteConvert}" ?? "NULL",
                                                style: TextStyle(
                                                    fontSize: 45,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black54),
                                              ),
                                            ],
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                height: MediaQuery.of(context).size.width * 0.4,
                                width: MediaQuery.of(context).size.width * 0.4,
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "WIB",
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 18),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "${_WIBTime}" ?? "NULL",
                                                style: TextStyle(
                                                    fontSize: 45,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black54),
                                              ),
                                              Text(
                                                "." ?? "NULL",
                                                style: TextStyle(
                                                    fontSize: 45,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black54),
                                              ),
                                              Text(
                                                "${_minuteConvert}" ?? "NULL",
                                                style: TextStyle(
                                                    fontSize: 45,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black54),
                                              ),
                                            ],
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
                            width: MediaQuery.of(context).size.width * 0.05,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                height: MediaQuery.of(context).size.width * 0.4,
                                width: MediaQuery.of(context).size.width * 0.4,
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "GMT",
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 18),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "${_GMTTime}" ?? "NULL",
                                                style: TextStyle(
                                                    fontSize: 45,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black54),
                                              ),
                                              Text(
                                                "." ?? "NULL",
                                                style: TextStyle(
                                                    fontSize: 45,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black54),
                                              ),
                                              Text(
                                                "${_minuteConvert}" ?? "NULL",
                                                style: TextStyle(
                                                    fontSize: 45,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black54),
                                              ),
                                            ],
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
                    ],
                  ),
                )),
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
                          "Konversi Waktu",
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
        currentIndex: 1,
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

  void convertTime() {
    int selectedHour = int.parse(_selectedItemHour);
    _minuteConvert = _selectedItemMinute;
    String selectedTime = _selectedTime;

    if (selectedTime == 'WIT') {
      _WITTime = _selectedItemHour;

      int WITATime = (selectedHour + 23) % 24;
      _WITATime = (WITATime < 10) ? '0$WITATime' : WITATime.toString();

      int WIBTime = (selectedHour + 22) % 24;
      _WIBTime = (WIBTime < 10) ? '0$WIBTime' : WIBTime.toString();

      int GMTTime = (selectedHour + 15) % 24;
      _GMTTime = (GMTTime < 10) ? '0$GMTTime' : GMTTime.toString();
    }
    else if (selectedTime == 'WITA') {
      _WITATime = _selectedItemHour;

      int WITTime = (selectedHour + 1) % 24;
      _WITTime = (WITTime < 10) ? '0$WITTime' : WITTime.toString();

      int WIBTime = (selectedHour + 23) % 24;
      _WIBTime = (WIBTime < 10) ? '0$WIBTime' : WIBTime.toString();

      int GMTTime = (selectedHour + 16) % 24;
      _GMTTime = (GMTTime < 10) ? '0$GMTTime' : GMTTime.toString();
    } else if (selectedTime == 'WIB') {
      _WIBTime = _selectedItemHour;

      int WITATime = (selectedHour + 1) % 24;
      _WITATime = (WITATime < 10) ? '0$WITATime' : WITATime.toString();

      int WITTime = (selectedHour + 2) % 24;
      _WITTime = (WITTime < 10) ? '0$WITTime' : WITTime.toString();

      int GMTTime = (selectedHour + 17) % 24;
      _GMTTime = (GMTTime < 10) ? '0$GMTTime' : GMTTime.toString();
    } else if (selectedTime == 'GMT') {
      _GMTTime = _selectedItemHour;

      int WITATime = (selectedHour + 8) % 24;
      _WITATime = (WITATime < 10) ? '0$WITATime' : WITATime.toString();

      int WIBTime = (selectedHour + 7) % 24;
      _WIBTime = (WIBTime < 10) ? '0$WIBTime' : WIBTime.toString();

      int WITTime = (selectedHour + 9) % 24;
      _WITTime = (WITTime < 10) ? '0$WITTime' : WITTime.toString();
    }

    setState(() {
      _WITTime = _WITTime;
      _WITATime = _WITATime;
      _WIBTime = _WIBTime;
      _GMTTime = _GMTTime;
      _minuteConvert = _selectedItemMinute;
    });
  }
}
