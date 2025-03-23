import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingController extends GetxController {
  final dio = Dio();
  var userData = <String, dynamic>{}.obs;
  var userImage = "";

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> logout() async {
    try {
      var response = await dio.post("http://localhost:4000/api/logout");
      print("Logout Successfully");
      Get.toNamed('/home');
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchUserData() async {
    try {
      final box = GetStorage();
      String? accessToken = box.read('token');
      int userId = box.read('userId');

      if (accessToken == null) {
        print("Error: Access Token is missing.");
        return;
      }

      var response = await dio.get(
        "http://localhost:4000/api/user/$userId",
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        userData.value = response.data; 
        userImage = response.data["profile"]["image"]["path"];
      } else {
        print("Error: Unexpected response format");
      }
    } catch (e) {
      print("Fetch user Error: $e");
    }
  }
}
