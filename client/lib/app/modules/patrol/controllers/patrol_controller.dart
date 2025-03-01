import 'package:flutter_densy_project/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class PatrolController extends GetxController {
  var patrolsData = <dynamic>[].obs;

  final dio = Dio();

  @override
  void onInit() {
    super.onInit();
    print("PatrolController initialized");
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final box = GetStorage();
      String? accessToken = box.read('token');

      if (accessToken == null) {
        print("Error: Access Token is missing.");
        return;
      }

      var response = await dio.get(
        "http://localhost:4000/api/patrols",
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        patrolsData.value =
            response.data; 
        print("Data fetched successfully: ${patrolsData}");
      } else {
        print("Error: Unexpected status code ${response.statusCode}");
      }
    } catch (e) {
      print("Fetch Error: $e");
    }
  }

  Future<void> logout() async {
    try {
      var response = await dio.post("http://localhost:4000/api/logout");
      print("Logout Successfully");
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      print(e);
    }
  }
}
