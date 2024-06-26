import 'dart:convert';
import 'dart:ui';
import 'package:crypt/crypt.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:weather_app/halamanLogin.dart';
import 'api_data_source.dart';
import 'model/modelDaerah.dart';

class HalamanRegister extends StatefulWidget {
  const HalamanRegister({super.key});

  @override
  State<HalamanRegister> createState() => _HalamanRegisterState();
}


class _HalamanRegisterState extends State<HalamanRegister> {
  bool isRegisterFailed = false;
  bool isProcessing = false;
  final formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _kelasController = TextEditingController();
  final TextEditingController _kesanController = TextEditingController();
  List _listData = [];
  bool siangHari = false;
  String _selectedItem = 'Kota Banda Aceh';
  List<ModelDaerah> _listWilayahFull = [];
  List<String> _listWilayah = [];
  late Future<void> _futureLoadWilayah;

  Future<void> _inputuser(String idTempat, String longitude, String latitute) async {
      final response = await http.post(Uri.parse(
          "https://weatherdatabaseaccount.000webhostapp.com/create.php"),
      body: {
        "nama": _namaController.text.toString(),
        "username": _usernameController.text.toString(),
        "password": Crypt.sha256(_passwordController.text).toString(),
        "nim": _nimController.text.toString(),
        "kelas": _kelasController.text.toString(),
        "tempatDefault": _selectedItem.toString(),
        "idTempat": idTempat,
        "longitude": longitude,
        "latitute": latitute,
        "kesanPesan": _kesanController.text.toString()
        });
  }


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
    _futureLoadWilayah = _loadWilayah();
    DateTime waktuSekarang = DateTime.now();
    int jamSekarang = waktuSekarang.hour;
    super.initState();
    if (jamSekarang > 6 && jamSekarang < 18) {
      siangHari = true;
    }
  }


  Future<void> _loadWilayah() async {
    try {
      List<dynamic> dynamicDataWilayah =
      await ApiDataSource.instance.getWilayah();
      List<ModelDaerah> dataWilayah = dynamicDataWilayah.map((dynamic item) {
        return ModelDaerah.fromJson(item as Map<String, dynamic>);
      }).toList();

      setState(() {
        _listWilayah = dataWilayah.map((wilayah) => wilayah.kota!).toList();
        _listWilayahFull = dataWilayah.toList();
        if (!_listWilayah.contains(_selectedItem)) {
          _selectedItem = _listWilayah.isNotEmpty ? _listWilayah[0] : '';
        }
      });
    } catch (error) {
      // Handle error
      print('Error fetching data: $error');
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
                    image:
                        siangHari
                            ?
                        const AssetImage("assets/afternoonSky.jpg")
                        :
                    const AssetImage("assets/nightSky.jpg")
                    ,
                    fit: BoxFit.cover)),
          ),
          SingleChildScrollView(
            child: isProcessing ?
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ) :  
            Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.075),
                child: Center(
                  child: Column(
                    children: [
                      FutureBuilder<void>(
                        future: _futureLoadWilayah,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            // Jika sedang dalam proses pengambilan data, tampilkan CircularProgressIndicator
                            return Center(
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            // Jika terjadi error saat pengambilan data
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          } else {
                            // Jika pengambilan data berhasil, tampilkan halaman utama
                            return SingleChildScrollView(
                              child: Form(
                                key: formKey,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 120,
                                    ),
                                    TextFormField(
                                      controller: _namaController,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Nama tidak boleh kosong";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        icon: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.5),
                                              borderRadius: BorderRadius.circular(20),
                                              border: Border.all(color: Colors.black54),
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.all(15.0),
                                              child: Icon(Icons
                                                  .drive_file_rename_outline_rounded,
                                                  color: Colors.black54),
                                            )),
                                        filled: true,
                                        focusColor: Colors.black,
                                        fillColor: Colors.white.withOpacity(0.5),
                                        hintText: 'Masukan nama anda',
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.white, width: 3),
                                            borderRadius: BorderRadius.circular(20)),
                                        labelStyle: const TextStyle(
                                            color: Colors.black12, fontSize: 18),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20.0),
                                          borderSide: const BorderSide(
                                            color: Colors.blue,
                                            width: 2.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.width * 0.05,
                                    ),
                                    TextFormField(
                                      controller: _usernameController,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Username tidak boleh kosong";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        icon: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.5),
                                              borderRadius: BorderRadius.circular(20),
                                              border: Border.all(color: Colors.black54),
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.all(15.0),
                                              child: Icon(Icons.account_circle,
                                                  color: Colors.black54),
                                            )),
                                        filled: true,
                                        focusColor: Colors.black,
                                        fillColor: Colors.white.withOpacity(0.5),
                                        hintText: 'Masukan username',
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.white, width: 3),
                                            borderRadius: BorderRadius.circular(20)),
                                        labelStyle: const TextStyle(
                                            color: Colors.black12, fontSize: 18),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20.0),
                                          borderSide: const BorderSide(
                                            color: Colors.blue,
                                            width: 2.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.width * 0.05,
                                    ),
                                    TextFormField(
                                      controller: _passwordController,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Password tidak boleh kosong";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        icon: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.5),
                                              borderRadius: BorderRadius.circular(20),
                                              border: Border.all(color: Colors.black54),
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.all(15.0),
                                              child: Icon(Icons.password_rounded,
                                                  color: Colors.black54),
                                            )),
                                        filled: true,
                                        focusColor: Colors.black,
                                        fillColor: Colors.white.withOpacity(0.5),
                                        hintText: 'Masukan password',
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.white, width: 3),
                                            borderRadius: BorderRadius.circular(20)),
                                        labelStyle: const TextStyle(
                                            color: Colors.black12, fontSize: 18),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20.0),
                                          borderSide: const BorderSide(
                                            color: Colors.blue,
                                            width: 2.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.width * 0.05,
                                    ),
                                    TextFormField(
                                      controller: _nimController,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "NIM tidak boleh kosong";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        icon: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.5),
                                              borderRadius: BorderRadius.circular(20),
                                              border: Border.all(color: Colors.black54),
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.all(15.0),
                                              child: Icon(Icons.perm_identity_rounded,
                                                  color: Colors.black54),
                                            )),
                                        filled: true,
                                        focusColor: Colors.black,
                                        fillColor: Colors.white.withOpacity(0.5),
                                        hintText: 'Masukan NIM',
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.white, width: 3),
                                            borderRadius: BorderRadius.circular(20)),
                                        labelStyle: const TextStyle(
                                            color: Colors.black12, fontSize: 18),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20.0),
                                          borderSide: const BorderSide(
                                            color: Colors.blue,
                                            width: 2.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.width * 0.05,
                                    ),
                                    TextFormField(
                                      controller: _kelasController,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Kelas tidak boleh kosong";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        icon: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.5),
                                              borderRadius: BorderRadius.circular(20),
                                              border: Border.all(color: Colors.black54),
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.all(15.0),
                                              child: Icon(Icons.meeting_room_rounded,
                                                  color: Colors.black54),
                                            )),
                                        filled: true,
                                        focusColor: Colors.black,
                                        fillColor: Colors.white.withOpacity(0.5),
                                        hintText: 'Masukan kelas',
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.white, width: 3),
                                            borderRadius: BorderRadius.circular(20)),
                                        labelStyle: const TextStyle(
                                            color: Colors.black12, fontSize: 18),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20.0),
                                          borderSide: const BorderSide(
                                            color: Colors.blue,
                                            width: 2.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.width * 0.05,
                                    ),
                                    DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                          icon: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.5),
                                                borderRadius: BorderRadius.circular(20),
                                                border: Border.all(color: Colors.black54),
                                              ),
                                              child: const Padding(
                                                padding: EdgeInsets.all(15.0),
                                                child: Icon(Icons.place_rounded,
                                                    color: Colors.black54),
                                              )
                                          ),
                                          filled: true,
                                          fillColor: Colors.white.withOpacity(0.5),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(20),
                                            borderSide: const BorderSide(color: Colors.black54),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.white, width: 3),
                                              borderRadius: BorderRadius.circular(20))
                                      ),
                                      focusColor: Colors.black,
                                      //fillColor: Colors.white.withOpacity(0.2),
                                      value: _selectedItem,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _selectedItem = newValue!;
                                        });
                                      },
                                      items: _listWilayah
                                          .map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.5,
                                              child: Text(
                                                value,
                                                overflow: TextOverflow.clip,
                                              ),),
                                        );
                                      }).toList(),
                                    ),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.width * 0.05,
                                    ),
                                    TextFormField(
                                      controller: _kesanController,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Kesan pesan tidak boleh kosong";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        icon: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.5),
                                              borderRadius: BorderRadius.circular(20),
                                              border: Border.all(color: Colors.black54),
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.all(15.0),
                                              child: Icon(Icons.description_rounded,
                                                  color: Colors.black54),
                                            )),
                                        filled: true,
                                        focusColor: Colors.black,
                                        fillColor: Colors.white.withOpacity(0.5),
                                        hintText: 'Masukan kesan & pesan',
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.white, width: 3),
                                            borderRadius: BorderRadius.circular(20)),
                                        labelStyle: const TextStyle(
                                            color: Colors.black12, fontSize: 18),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20.0),
                                          borderSide: const BorderSide(
                                            color: Colors.blue,
                                            width: 2.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    if(isRegisterFailed) (
                                        SizedBox(
                                          height: MediaQuery.of(context).size.width * 0.1,
                                          child: const Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Username telah digunakan orang lain.",
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                    ),
                                    if(isRegisterFailed==false) (
                                    SizedBox(
                                      height: MediaQuery.of(context).size.width * 0.1,
                                    )
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if(formKey.currentState!.validate()) {
                                              submit();
                                            }
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
                                                    Icons.input_rounded,
                                                    size: 30,
                                                    color: Colors.white,
                                                  ),
                                                  Text(
                                                    "SUBMIT",
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
                                    SizedBox(
                                      height: MediaQuery.of(context).size.width * 0.1,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(left: 11.5),
                                          child: Text(
                                            "Sudah ada akun?",
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
                                                        const HalamanLogin()));
                                          },
                                          child: const Text(
                                            'Login',
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
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                )
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
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(100)),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          "Register",
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
    );
  }

  Future<void> submit() async {
  String username = _usernameController.text;

  int banyakAkun = _listData.length;
  for(int x = 0; x < banyakAkun; x++) {
    if(username == _listData[x]["username"]) {
      setState(() {
        isRegisterFailed = true;
      });
    }
  }

  if (isRegisterFailed == false) {
    int banyakWilayah = _listWilayahFull.length;
    for(int y = 0; y < banyakWilayah; y++) {
      if (_selectedItem == _listWilayahFull[y].kota) {
        String? idTempat = _listWilayahFull[y].id;
        String? longitude = _listWilayahFull[y].lon;
        String? latitute = _listWilayahFull[y].lat;
        
        setState(() {
          isProcessing = true;
        });

         await _inputuser(idTempat!, longitude!, latitute!);
        
        // Menunda navigasi ke halaman login selama 2 detik
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const HalamanLogin(),
          ),
        );
        break;
      }
    }
  }
}

}
