import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class DetailController extends GetxController {
  var patrolDetail = {}.obs; 
  var presetsData = {}.obs; 
  var patrolDetailResult = [].obs; 
  var startPatrolResult = [].obs;
  final dio = Dio();
  var totalItems = 0.obs;

  @override
  void onInit() {
    super.onInit();
    print("DetailController initialized");
    fetchPatrolDetail();
  }

  @override
  void onClose() {
    super.onClose();
    patrolDetail.clear();
    presetsData.clear();
    patrolDetailResult.clear();
  }

  Future<void> fetchPatrolDetail() async {
    totalItems.value = 0;
    final patrolId = Get.parameters['id'];
    final box = GetStorage();
    String? accessToken = box.read('token');

    if (patrolId == null || accessToken == null) {
      print("Patrol ID or Token is missing!");
      return;
    }

    print("Fetching patrol detail for ID: $patrolId");

    try {
      var response = await dio.get(
        "http://localhost:4000/api/patrol/$patrolId",
        queryParameters: {"result": "true"},
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        if (response.data is Map) {
          patrolDetail.value = response.data;
          patrolDetailResult.value = response.data["results"] ?? []; 

          // Funtion นับ Item
          for (var checklist in response.data["patrolChecklists"]) {
            totalItems.value += (checklist["checklist"]["items"].length as int);
          }
          await fetchPresetData();
        } else {
          print("Error: Expected a Map response, but got a List");
        }
      } else {
        print("Error: Unexpected status code ${response.statusCode}");
      }
    } on DioException catch (e) {
      print("DioError fetching patrol detail: ${e.message}");
    } catch (e) {
      print("Unexpected error fetching patrol detail: ${e.toString()}");
    }
  }

  Future<void> startPatrolDetail() async {
    final patrolId = Get.parameters['id'];
    final box = GetStorage();
    String? accessToken = box.read('token');

    if (patrolId == null || accessToken == null) {
      print("Patrol ID or Token is missing!");
      return;
    }

    print("Starting patrol for ID: $patrolId");

    var patrolChecklists = patrolDetail.value['patrolChecklists'];
    if (patrolChecklists == null || patrolChecklists.isEmpty) {
      print("No patrol checklists available.");
      return;
    }

    var requestPayload = {
      'status': 'scheduled', // Set status to scheduled
      'checklists': _mapChecklistsForStart(patrolChecklists),
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

      if (response.statusCode == 200) {
        print("Patrol started successfully");
        onInit();
      } else {
        print("Error: Unexpected status code ${response.statusCode}");
      }
    } on DioException catch (e) {
      print("DioError starting patrol: ${e.message}");
    } catch (e) {
      print("Unexpected error starting patrol: ${e.toString()}");
    }
  }

  List<Map<String, dynamic>> _mapChecklistsForStart(List<dynamic> patrolChecklists) {
    return patrolChecklists.map<Map<String, dynamic>>((checklistObj) {
      return {
        'id': checklistObj['id'] ?? 0,
        'patrolId': checklistObj['patrolId'] ?? 0,
        'checklistId': checklistObj['checklist']?['id'] ?? 0,
        'userId': checklistObj['userId'] ?? 0,
        'checklist': {
          'id': checklistObj['checklist']?['id'] ?? 0,
          'title': checklistObj['checklist']?['title'] ?? '',
          'items': checklistObj['checklist']?['items']?.map((item) {
            return {
              'id': item['id'] ?? 0,
              'name': item['name'] ?? '',
              'type': item['type'] ?? '',
              'checklistId': item['checklistId'] ?? 0,
              'itemZones': item['itemZones']?.map((zone) {
                return {
                  'zone': {
                    'id': zone['zone']?['id'] ?? 0,
                    'name': zone['zone']?['name'] ?? '',
                    'supervisor': {
                      'id': zone['zone']?['supervisor']?['id'] ?? 0,
                      'profile': zone['zone']?['supervisor']?['profile'] ?? {},
                    },
                  },
                };
              })?.toList() ?? [],
            };
          })?.toList() ?? [],
        },
        'inspector': {
          'id': checklistObj['inspector']?['id'] ?? 0,
          'role': checklistObj['inspector']?['role'] ?? '',
          'profile': checklistObj['inspector']?['profile'] ?? {},
        },
      };
    }).toList();
  }

  Future<void> fetchPresetData() async {
    try {
      final box = GetStorage();
      String? accessToken = box.read('token');

      if (accessToken == null) {
        print("Error: Access Token is missing.");
        return;
      }

      final presetId = patrolDetail["presetId"];
      if (presetId == null) {
        print("Error: Preset ID is missing.");
        return;
      }

      var response = await dio.get(
        "http://localhost:4000/api/preset/$presetId",
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
    } on DioException catch (e) {
      print("DioError fetching preset data: ${e.message}");
    } catch (e) {
      print("Unexpected error fetching preset data: ${e.toString()}");
    }
  }

  void updateResultStatus(int itemId, int zoneId, bool status) {
    final resultIndex = patrolDetailResult.indexWhere(
      (result) => result["itemId"] == itemId && result["zoneId"] == zoneId,
    );
    if (resultIndex != -1) {
      patrolDetailResult[resultIndex]["status"] = status;
      patrolDetailResult.refresh(); 
    }
  }

 Future<void> finishPatrolDetail() async {
    final patrolId = Get.parameters['id'];
    final box = GetStorage();
    String? accessToken = box.read('token');

    if (patrolId == null || accessToken == null) {
      print("Patrol ID or Token is missing!");
      Get.snackbar("Error", "Patrol ID or Token is missing!");
      return;
    }

    print("Finishing patrol for ID: $patrolId");

    var patrolChecklists = patrolDetail.value['patrolChecklists'];
    if (patrolChecklists == null || patrolChecklists.isEmpty) {
      print("No patrol checklists available.");
      Get.snackbar("Error", "No patrol checklists available.");
      return;
    }

    print(totalItems.value);
    print("-------");
      print(startPatrolResult.length);
    if (startPatrolResult.length != totalItems.value) {
      Get.snackbar("Fail", "Cannot finish patrol Not all checklist items are completed.");
      return; 
    }

    var requestPayload = {
      'status': 'on_going', // Set status to completed
      'checklists': _mapChecklistsForFinish(patrolChecklists),
      'results': _mapResults(patrolDetailResult),
      'endTime': DateTime.now().toUtc().toIso8601String(), // Add the end time
    };

    try {
      var response = await dio.put(
        "http://localhost:4000/api/patrol/$patrolId/finish",
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
        data: requestPayload,
      );

      if (response.statusCode == 200) {
        print("Patrol finished successfully");
        Get.snackbar("Success", "Patrol finished successfully");
        onInit();
      } else {
        print("Error: Unexpected status code ${response.statusCode}");
        Get.snackbar("Error", "Unexpected status code ${response.statusCode}");
      }
    } on DioException catch (e) {
      print("DioError finishing patrol: ${e.message}");
      Get.snackbar("Error", "Failed to finish patrol: ${e.message}");
    } catch (e) {
      print("Unexpected error finishing patrol: ${e.toString()}");
      Get.snackbar("Error", "Unexpected error: ${e.toString()}");
    }
  }

  List<Map<String, dynamic>> _mapChecklistsForFinish(List<dynamic> patrolChecklists) {
    return patrolChecklists.map((checklist) {
      return {
        'id': checklist['id'],
        'patrolId': checklist['patrolId'],
        'checklistId': checklist['checklistId'],
        'userId': checklist['userId'],
        'checklist': {
          'id': checklist['checklist']['id'],
          'title': checklist['checklist']['title'],
          'items': checklist['checklist']['items'].map((item) {
            return {
              'id': item['id'],
              'name': item['name'],
              'type': item['type'],
              'checklistId': item['checklistId'],
              'itemZones': item['itemZones'].map((itemZone) {
                return {
                  'zone': {
                    'id': itemZone['zone']['id'],
                    'name': itemZone['zone']['name'],
                  },
                };
              }).toList(),
            };
          }).toList(),
        },
        'inspector': {
          'id': checklist['inspector']['id'],
          'email': checklist['inspector']['email'],
          'profile': checklist['inspector']['profile'],
        },
      };
    }).toList();
  }

  List<Map<String, dynamic>> _mapResults(List<dynamic> patrolDetailResult) {
    return patrolDetailResult.map((result) {
      return {
        'id': result['id'],
        'status': result['status'],
        'itemId': result['itemId'],
        'zoneId': result['zoneId'],
        'patrolId': result['patrolId'],
        'defects': result['defects'].map((defect) {
          return {
            'id': defect['id'],
            'name': defect['name'],
            'description': defect['description'],
            'type': defect['type'],
            'status': defect['status'],
            'timestamp': defect['timestamp'],
            'userId': defect['userId'],
            'patrolResultId': defect['patrolResultId'],
          };
        }).toList(),
        'comments': result['comments'].map((comment) {
          return {
            'id': comment['id'],
            'text': comment['text'],
            'timestamp': comment['timestamp'],
            'userId': comment['userId'],
            'patrolResultId': comment['patrolResultId'],
          };
        }).toList(),
      };
    }).toList();
  }

  Future<void> postComment(String message, int patrolResultId, int supervisorId) async {
    try {
      final patrolId = Get.parameters['id'];
      final box = GetStorage();
      String? accessToken = box.read('token');

      final response = await dio.post(
        'http://192.168.53.101:4000/api/patrol/$patrolId/comment',
        data: {
          'message': message,
          'patrolResultId': patrolResultId,
          'supervisorId': supervisorId,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      Get.snackbar("Success", "Create Comment Successful");
      print(response.data);
    } catch (e) {
      print("Error: $e");
      Get.snackbar("Error", "Failed to Create Comment, $patrolResultId , $supervisorId, $message");
    }
  }
}