import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class DetailController extends GetxController {
  var patrolDetail = {}.obs; // เก็บข้อมูลของ Patrol ที่ถูกเลือก
  final dio = Dio();

  @override
  void onInit() {
    print("DetailController initialized");
    super.onInit();
    fetchPatrolDetail();
  }

  Future<void> fetchPatrolDetail() async {
  final patrolId = Get.parameters['id'];
  final box = GetStorage();
  String? accessToken = box.read('token');
  print("Fetching patrol detail for ID: $patrolId");
  if (patrolId == null) return;

  try {
    var response = await dio.get("http://localhost:4000/api/patrol/$patrolId",
      queryParameters: {
        "result": "true"
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );
    print("API Response: ${response.data}");
    patrolDetail.value = response.data;
  } catch (e) {
    print("Error fetching patrol detail: $e");
  }
}

}
