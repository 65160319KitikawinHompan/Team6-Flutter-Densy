import 'package:get/get.dart';
import 'package:dio/dio.dart';

class DetailController extends GetxController {
  var patrolDetail = {}.obs; // เก็บข้อมูลของ Patrol ที่ถูกเลือก
  final dio = Dio();

  @override
  void onInit() {
    super.onInit();
    fetchPatrolDetail();
  }

  Future<void> fetchPatrolDetail() async {
    final patrolId = Get.parameters['id']; // ✅ ดึงจาก URL
    if (patrolId == null) {
      print("Error: No Patrol ID provided.");
      return;
    }

    try {
      var response =
          await dio.get("http://localhost:4000/api/patrols/$patrolId");
      if (response.statusCode == 200) {
        patrolDetail.value = response.data;
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Fetch Detail Error: $e");
    }
  }
}
