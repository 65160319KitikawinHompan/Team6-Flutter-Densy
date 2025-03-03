import 'package:flutter_densy_project/app/routes/app_pages.dart';
import 'package:flutter_densy_project/app/utils/create_patrol_view.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class PatrolController extends GetxController {
  var userData = <String, dynamic>{}.obs;
  var patrolsData = <dynamic>[].obs;
  var presetsData = <dynamic>[].obs;
  var filteredPatrols = <dynamic>[].obs; 
  var searchText = ''.obs;

  final dio = Dio();

  @override
  void onInit() {
    super.onInit();
    print("PatrolController initialized");
    fetchPatrolData();
    fetchPresetData();
    fetchUserData();
  }

  void searchPatrols(String query) {
    searchText.value = query.toLowerCase(); 

  if (query.isEmpty) {
    filteredPatrols.assignAll(patrolsData); // Reset คำ Searh ให้ว่างเปล่า
  } else {
    filteredPatrols.value = patrolsData.where((patrol) {
      final title = patrol['preset']['title'].toString().toLowerCase();
      final status = patrol['status'].toString().toLowerCase();
      final date = patrol['date'].toString().toLowerCase();

      return title.contains(searchText.value) || status.contains(searchText.value) || date.contains(searchText.value);
    }).toList();
  }
    print("filter : ${filteredPatrols.value}");
     print("user : ${userData['profile']['image']['path']}");
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
      } else {
        print("Error: Unexpected response format");
      }
    } catch (e) {
      print("Fetch user Error: $e");
    }
  }


  Future<void> fetchPatrolData() async {
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
        patrolsData.value = response.data; 
         filteredPatrols.assignAll(patrolsData);
      } else {
        print("Error: Unexpected status code ${response.statusCode}");
      }
    } catch (e) {
      print("Fetch Error: $e");
    }
  }

  Future<void> fetchPresetData() async {
    try {
      final box = GetStorage();
      String? accessToken = box.read('token');

      if (accessToken == null) {
        print("Error: Access Token is missing.");
        return;
      }

      var response = await dio.get(
        "http://localhost:4000/api/presets",
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        presetsData.value = response.data; 
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

  Future<void> createPatrolView() async {
    await Get.dialog(
      PatrolPresetPage(),
      barrierDismissible: false, 
    );
  }

  Future<void> postPatrol(String date, int presetId, List<Map<String, int>> checklists) async {
    try {
      final box = GetStorage();
      String? accessToken = box.read('token');

      final response = await dio.post(
        'http://192.168.53.101:4000/api/patrol',
        data: {
          'date': date,
          'presetId': presetId,
          'checklists': checklists,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      Get.snackbar("Success", "Create Patrol Successful");
    } catch (e) {
      print("Error: $e");
      Get.snackbar("Error", "Failed to Create Patrol");
    }
  }
}
