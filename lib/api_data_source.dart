// import 'base_network.dart';
// class ApiDataSource {
//   static ApiDataSource instance = ApiDataSource();
//   Future<List<dynamic>> loadListDaerah() {
//     return BaseNetwork.get("wilayah.json");
//   }
// }

import 'base_network.dart';

class ApiDataSource {
  static ApiDataSource instance = ApiDataSource();

  Future<List<dynamic>> getWilayah() async {
    return BaseNetwork.get('cuaca/wilayah.json');
  }

  Future<List<dynamic>> getCuaca(String idWilayah) async {
    return BaseNetwork.get('cuaca/$idWilayah.json');
  }
}