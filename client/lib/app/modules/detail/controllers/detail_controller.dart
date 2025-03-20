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
      patrolDetail.value = response.data;
      print("API Response: ${patrolDetail}");
    } catch (e) {
      print("Error fetching patrol detail: $e");
    }
  }

  Future<void> startPatrolDetail() async {
    final patrolId = Get.parameters['id'];
    final box = GetStorage();
    String? accessToken = box.read('token');
    print("Starting patrol for ID: $patrolId");

    if (patrolId == null) return;

    // Prepare the checklists in the required format
    List<Map<String, dynamic>> checklists = [];

    if (patrolDetail.value['patrolChecklists'] == null) {
      print("No patrol checklists available.");
      return;
    }

    for (var checklistObj in patrolDetail.value['patrolChecklists'] ?? []) {
      var checklistData = {
        'id': checklistObj['id'] ?? 0,
        'patrolId': checklistObj['patrolId'] ?? 0,
        'checklistId': checklistObj['checklist']?['id'] ?? 0,
        'userId': checklistObj['userId'] ?? 0,
        'checklist': {
          'id': checklistObj['checklist']?['id'] ?? 0,
          'title': checklistObj['checklist']?['title'] ?? '',
          'items': []
        },
        'inspector': {
          'id': checklistObj['inspector']?['id'] ?? 0,
          'role': checklistObj['inspector']?['role'] ?? '',
          'profile': checklistObj['inspector']?['profile'] ?? {}
        }
      };

      if (checklistObj['checklist'] != null && checklistObj['checklist']['items'] != null) {
        for (var item in checklistObj['checklist']['items'] ?? []) {
          var itemData = {
            'id': item['id'] ?? 0,
            'name': item['name'] ?? '',
            'type': item['type'] ?? '',
            'checklistId': item['checklistId'] ?? 0,
            'itemZones': []
          };

          for (var zone in item['itemZones'] ?? []) {
            itemData['itemZones'].add({
              'zone': {
                'id': zone['zone']?['id'] ?? 0,
                'name': zone['zone']?['name'] ?? '',
                'supervisor': {
                  'id': zone['zone']?['supervisor']?['id'] ?? 0,
                  'profile': zone['zone']?['supervisor']?['profile'] ?? {}
                }
              }
            });
          }

          checklistData['checklist']['items'].add(itemData);
        }
      }

      checklists.add(checklistData);
    }

    var requestPayload = {
      'status': 'scheduled', // Set status to scheduled
      'checklists': checklists,
    };

    try {
      var response = await dio.put(
        "http://localhost:4000/api/patrol/$patrolId/start",
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
        data: requestPayload,
      );
      print("API Response: ${response.data}");

    } catch (e) {
      print("Error starting patrol: $e");
    }
  }

  @override
  void onClose() {
    super.onClose();
    // Reset patrolDetail to clear old data
    patrolDetail.value = {};
  }
}
