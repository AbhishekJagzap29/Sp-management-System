
//corrected code----------------------------------------------------------------------------------
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sp_manage_system/API/Response%20Model/count_res_model.dart';
import 'package:sp_manage_system/API/Response%20Model/police_station_res_model.dart';
import 'package:sp_manage_system/API/Response%20Model/sp_res_model.dart';
import 'package:sp_manage_system/API/Response%20Model/time_slot_res_model.dart';
import 'package:sp_manage_system/API/Service/api_service.dart';
import 'package:sp_manage_system/API/Service/base_service.dart';
import 'package:sp_manage_system/Screen/Constant/shared_prefs.dart';

class ProjectRepo {
  Map<String, String> header = {
    'Cookie':
        'Cookie_1=value; ${preferences.getString(SharedPreference.sessionId)}'
  };
  Map<String, String> header1 = {
    'Content-Type': 'application/json',
    'Cookie':
        'Cookie_1=value; ${preferences.getString(SharedPreference.sessionId)}'
  };

  /// citizen complaint form submit ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

  Future<dynamic> spList({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.spList,
      apiType: APIType.aGet,
      body: body,
      header: header,
    );

    log('spResponseModel --- response>> $response');

    SpResponseModel spResponseModel = SpResponseModel.fromJson(response);

    log('spResponseModel --- response>> $response');

    return spResponseModel;
  }

  Future<dynamic> getPoliceStations({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.getPoliceStations,
      apiType: APIType.aGet,
      body: body,
      header: header,
    );

    log('policeStationResponseModel --- response>> $response');

    PoliceStationResponseModel policeStationResponseModel =
        PoliceStationResponseModel.fromJson(response);

    log('policeStationResponseModel --- response>> $response');

    return policeStationResponseModel;
  }

  Future<dynamic> getTimeSlot({Map<String, dynamic>? body}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.getTimeSlot,
      apiType: APIType.aGet,
      body: body,
      header: header,
    );

    log('timeSlotResponseModel --- response>> $response');

    TimeSlotResponseModel timeSlotResponseModel =
        TimeSlotResponseModel.fromJson(response);

    log('timeSlotResponseModel --- response>> $response');

    return timeSlotResponseModel;
  }

  Future<dynamic> getStatusCount({Map<String, dynamic>? body, required int policeStationId}) async {
    var response = await APIService().getResponse(
      url: ApiRouts.statusCount,
      apiType: APIType.aGet,
      body: body,
      header: header,
    );

    log('statusCountResponseModel --- response>> $response');

    StatusCountResponseModel statusCountResponseModel =
        StatusCountResponseModel.fromJson(response);

    log('statusCountResponseModel --- response>> $response');

    return statusCountResponseModel;
  }

  // Future<StatusCountResponseModel?> getPiStatusCounts() async {
  //   try {
  //     // Get current user ID from your authentication system
  //     int userId = await getCurrentUserId(); // You need to implement this method
      
  //     final response = await http.post(
  //       Uri.parse(ApiRouts.piStatusCount),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({'user_id': userId}),
  //     );

  //     if (response.statusCode == 200) {
  //       return statusCountResponseModelFromJson(response.body);
  //     } else {
  //       debugPrint("PI Status Count API Error: ${response.statusCode}");
  //       return null;
  //     }
  //   } catch (e) {
  //     debugPrint("PI Status Count Exception: $e");
  //     return null;
  //   }
  // }

  // // Helper method to get current user ID - you need to implement this based on your auth system
  // Future<int> getCurrentUserId() async {
  //   // This should return the currently logged-in user's ID
  //   // Example: return SharedPreferences.getInstance().then((prefs) => prefs.getInt('userId') ?? 0);
  //   return 1; // Replace with actual implementation
  // }

// In ProjectRepo class
Future<int> getCurrentUserId() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    
    debugPrint("🔍 Searching for User ID in SharedPreferences...");
    
    // Method 1: Get from userId key (you're storing this in AuthController)
    final userIdString = prefs.getString(SharedPreference.userId);
    if (userIdString != null && userIdString.isNotEmpty) {
      final userId = int.tryParse(userIdString);
      if (userId != null) {
        debugPrint("✅ User ID found in SharedPreference.userId: $userId");
        return userId;
      }
    }
    
    // Method 2: Get from userLoginData (entire login response)
    final userLoginDataString = prefs.getString(SharedPreference.userLoginData);
    if (userLoginDataString != null) {
      debugPrint("📦 User Login Data found, parsing...");
      final loginData = jsonDecode(userLoginDataString);
      debugPrint("👤 Full Login Data: $loginData");
      
      // Extract user ID from login response structure
      // Based on your AuthController, you're storing LoginResponseModel
      dynamic userId = loginData['uid'] ?? 
                      loginData['user_id'] ?? 
                      loginData['id'];
      
      if (userId != null) {
        // Handle different data types
        if (userId is int) {
          debugPrint("✅ User ID from userLoginData: $userId");
          return userId;
        } else if (userId is String) {
          final parsedId = int.tryParse(userId);
          if (parsedId != null) {
            debugPrint("✅ User ID from userLoginData (string): $parsedId");
            return parsedId;
          }
        }
      }
      
      // Also check for user ID in nested structures
      if (loginData['user'] != null) {
        final userData = loginData['user'];
        dynamic nestedUserId = userData['uid'] ?? 
                              userData['user_id'] ?? 
                              userData['id'];
        if (nestedUserId != null && nestedUserId is int) {
          debugPrint("✅ User ID from nested user data: $nestedUserId");
          return nestedUserId;
        }
      }
    }
    
    // Method 3: Check other possible storage locations
    final directUserId = prefs.getInt('userId');
    if (directUserId != null) {
      debugPrint("✅ User ID from direct 'userId' key: $directUserId");
      return directUserId;
    }
    
    // If nothing found, throw detailed error
    final availableKeys = prefs.getKeys();
    debugPrint("🔍 Available SharedPreferences keys: $availableKeys");
    
    throw Exception("""
User ID not found in local storage. 
Available keys: $availableKeys
Expected keys: 
- ${SharedPreference.userId}
- ${SharedPreference.userLoginData}
- userId
""");
    
  } catch (e) {
    debugPrint("❌ Error getting user ID: $e");
    rethrow;
  }
}

Future<StatusCountResponseModel?> getPiStatusCounts() async {
  try {
    // Get current user ID from your authentication system
    int userId = await getCurrentUserId();
    
    final Map<String, dynamic> requestBody = {
      'user_id': userId,
    };

    debugPrint("📡 Calling PI Status Count API: ${ApiRouts.piStatusCount}");
    debugPrint("📦 Request Body: $requestBody");

    final response = await http.post(
      Uri.parse(ApiRouts.piStatusCount),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    debugPrint("📥 Response Status Code: ${response.statusCode}");
    debugPrint("📥 Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final result = statusCountResponseModelFromJson(response.body);
      debugPrint("✅ PI Status Count API Success: ${result.status}");
      return result;
    } else {
      debugPrint("❌ PI Status Count API Error: ${response.statusCode} - ${response.body}");
      return StatusCountResponseModel(
        status: 'error',
        counts: {}, // Provide an empty map for counts
        message: 'API Error: ${response.statusCode}',
      );
    }
  } catch (e) {
    debugPrint("💥 PI Status Count Exception: $e");
    return StatusCountResponseModel(
      status: 'error',
      counts: {}, // Pass an empty map instead of a list
      message: 'Network Error: $e',
    );
  }
}
}






















// import 'dart:convert';
// import 'dart:developer';

// import 'package:http/http.dart' as http;
// import 'package:sp_manage_system/API/Response%20Model/count_res_model.dart';
// import 'package:sp_manage_system/API/Response%20Model/police_station_res_model.dart';
// import 'package:sp_manage_system/API/Response%20Model/sp_res_model.dart';
// import 'package:sp_manage_system/API/Response%20Model/time_slot_res_model.dart';
// import 'package:sp_manage_system/API/Service/api_service.dart';
// import 'package:sp_manage_system/API/Service/base_service.dart';
// import 'package:sp_manage_system/Screen/Constant/shared_prefs.dart';

// class ProjectRepo {
//   Map<String, String> header = {
//     'Cookie':
//         'Cookie_1=value; ${preferences.getString(SharedPreference.sessionId)}'
//   };
//   Map<String, String> header1 = {
//     'Content-Type': 'application/json',
//     'Cookie':
//         'Cookie_1=value; ${preferences.getString(SharedPreference.sessionId)}'
//   };

//   /// citizen complaint form submit ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

//   Future<dynamic> spList({Map<String, dynamic>? body}) async {
//     var response = await APIService().getResponse(
//       url: ApiRouts.spList,
//       apiType: APIType.aGet,
//       body: body,
//       header: header,
//     );

//     log('spResponseModel --- response>> $response');

//     SpResponseModel spResponseModel = SpResponseModel.fromJson(response);

//     log('spResponseModel --- response>> $response');

//     return spResponseModel;
//   }

//   Future<dynamic> getPoliceStations({Map<String, dynamic>? body}) async {
//     var response = await APIService().getResponse(
//       url: ApiRouts.getPoliceStations,
//       apiType: APIType.aGet,
//       body: body,
//       header: header,
//     );

//     log('policeStationResponseModel --- response>> $response');

//     PoliceStationResponseModel policeStationResponseModel =
//         PoliceStationResponseModel.fromJson(response);

//     log('policeStationResponseModel --- response>> $response');

//     return policeStationResponseModel;
//   }

//   Future<dynamic> getTimeSlot({Map<String, dynamic>? body}) async {
//     var response = await APIService().getResponse(
//       url: ApiRouts.getTimeSlot,
//       apiType: APIType.aGet,
//       body: body,
//       header: header,
//     );

//     log('timeSlotResponseModel --- response>> $response');

//     TimeSlotResponseModel timeSlotResponseModel =
//         TimeSlotResponseModel.fromJson(response);

//     log('timeSlotResponseModel --- response>> $response');

//     return timeSlotResponseModel;
//   }

//   Future<dynamic> getStatusCount({Map<String, dynamic>? body}) async {
//     var response = await APIService().getResponse(
//       url: ApiRouts.statusCount,
//       apiType: APIType.aGet,
//       body: body,
//       header: header,
//     );

//     log('statusCountResponseModel --- response>> $response');

//     StatusCountResponseModel statusCountResponseModel =
//         StatusCountResponseModel.fromJson(response);

//     log('statusCountResponseModel --- response>> $response');

//     return statusCountResponseModel;
//   }


//   /// ---------------- Existing dynamic method ----------------
//   Future<dynamic> getPoliceStationsDynamic({Map<String, dynamic>? body}) async {
//     try {
//       final response = await http.post(
//         Uri.parse(ApiRouts.getPoliceStations),
//         headers: header1,
//         body: jsonEncode(body ?? {}),
//       );
//       log("getPoliceStationsDynamic raw response: ${response.body}");

//       if (response.statusCode == 200) {
//         return jsonDecode(response.body);
//       } else {
//         throw Exception("Error: ${response.body}");
//       }
//     } catch (e) {
//       log("getPoliceStationsDynamic error: $e");
//       rethrow;
//     }
//   }

//   /// ---------------- Corrected strongly typed method ----------------
//   Future<PoliceStationResponseModel> fetchPoliceStationsList() async {
//     try {
//       final response = await http.get(
//         Uri.parse(ApiRouts.getPoliceStations),
//         headers: header,
//       );
//       log("fetchPoliceStationsList raw response: ${response.body}");

//       if (response.statusCode == 200) {
//         return policeStationResponseModelFromJson(response.body);
//       } else {
//         throw Exception("Error fetching police stations: ${response.body}");
//       }
//     } catch (e) {
//       log("fetchPoliceStationsList error: $e");
//       rethrow;
//     }
//   }

//   /// ---------------- Example for psStatusCounts ----------------
//  Future<dynamic> getPsStatusCounts({required int psId}) async {
//   try {
//     final response = await http.post(
//       Uri.parse(ApiRouts.getPsStatusCounts),
//       headers: header1,
//       body: jsonEncode({"ps_id": psId}),
//     );
//     log("getPsStatusCounts response: ${response.body}");

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception("Error fetching psStatusCounts: ${response.body}");
//     }
//   } catch (e) {
//     log("getPsStatusCounts error: $e");
//     rethrow;
//   }
// }


  
// }


















//corrected code----------------------------------------------------------------------------------
// import 'dart:developer';

// import 'package:sp_manage_system/API/Response%20Model/count_res_model.dart';
// import 'package:sp_manage_system/API/Response%20Model/police_station_res_model.dart';
// import 'package:sp_manage_system/API/Response%20Model/sp_res_model.dart';
// import 'package:sp_manage_system/API/Response%20Model/time_slot_res_model.dart';
// import 'package:sp_manage_system/API/Service/api_service.dart';
// import 'package:sp_manage_system/API/Service/base_service.dart';
// import 'package:sp_manage_system/Screen/Constant/shared_prefs.dart';

// class ProjectRepo {
//   Map<String, String> header = {
//     'Cookie':
//         'Cookie_1=value; ${preferences.getString(SharedPreference.sessionId)}'
//   };
//   Map<String, String> header1 = {
//     'Content-Type': 'application/json',
//     'Cookie':
//         'Cookie_1=value; ${preferences.getString(SharedPreference.sessionId)}'
//   };

//   /// citizen complaint form submit ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

//   Future<dynamic> spList({Map<String, dynamic>? body}) async {
//     var response = await APIService().getResponse(
//       url: ApiRouts.spList,
//       apiType: APIType.aGet,
//       body: body,
//       header: header,
//     );

//     log('spResponseModel --- response>> $response');

//     SpResponseModel spResponseModel = SpResponseModel.fromJson(response);

//     log('spResponseModel --- response>> $response');

//     return spResponseModel;
//   }

//   Future<dynamic> getPoliceStations({Map<String, dynamic>? body}) async {
//     var response = await APIService().getResponse(
//       url: ApiRouts.getPoliceStations,
//       apiType: APIType.aGet,
//       body: body,
//       header: header,
//     );

//     log('policeStationResponseModel --- response>> $response');

//     PoliceStationResponseModel policeStationResponseModel =
//         PoliceStationResponseModel.fromJson(response);

//     log('policeStationResponseModel --- response>> $response');

//     return policeStationResponseModel;
//   }

//   Future<dynamic> getTimeSlot({Map<String, dynamic>? body}) async {
//     var response = await APIService().getResponse(
//       url: ApiRouts.getTimeSlot,
//       apiType: APIType.aGet,
//       body: body,
//       header: header,
//     );

//     log('timeSlotResponseModel --- response>> $response');

//     TimeSlotResponseModel timeSlotResponseModel =
//         TimeSlotResponseModel.fromJson(response);

//     log('timeSlotResponseModel --- response>> $response');

//     return timeSlotResponseModel;
//   }

//   Future<dynamic> getStatusCount({Map<String, dynamic>? body}) async {
//     var response = await APIService().getResponse(
//       url: ApiRouts.statusCount,
//       apiType: APIType.aGet,
//       body: body,
//       header: header,
//     );

//     log('statusCountResponseModel --- response>> $response');

//     StatusCountResponseModel statusCountResponseModel =
//         StatusCountResponseModel.fromJson(response);

//     log('statusCountResponseModel --- response>> $response');

//     return statusCountResponseModel;
//   }

  
// }



















// import 'dart:developer';

// import 'package:sp_manage_system/API/Response%20Model/police_station_res_model.dart';
// import 'package:sp_manage_system/API/Response%20Model/sp_res_model.dart';
// import 'package:sp_manage_system/API/Response%20Model/time_slot_res_model.dart';
// import 'package:sp_manage_system/API/Service/api_service.dart';
// import 'package:sp_manage_system/API/Service/base_service.dart';
// import 'package:sp_manage_system/Screen/Constant/shared_prefs.dart';

// class ProjectRepo {
//   Map<String, String> header = {
//     'Cookie':
//         'Cookie_1=value; ${preferences.getString(SharedPreference.sessionId)}'
//   };
//   Map<String, String> header1 = {
//     'Content-Type': 'application/json',
//     'Cookie':
//         'Cookie_1=value; ${preferences.getString(SharedPreference.sessionId)}'
//   };

//   /// citizen complaint form submit ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

//   Future<dynamic> spList({Map<String, dynamic>? body}) async {
//     var response = await APIService().getResponse(
//       url: ApiRouts.spList,
//       apiType: APIType.aGet,
//       body: body,
//       header: header,
//     );

//     log('spResponseModel --- response>> $response');

//     SpResponseModel spResponseModel = SpResponseModel.fromJson(response);

//     log('spResponseModel --- response>> $response');

//     return spResponseModel;
//   }

//   Future<dynamic> getPoliceStations({Map<String, dynamic>? body}) async {
//     var response = await APIService().getResponse(
//       url: ApiRouts.getPoliceStations,
//       apiType: APIType.aGet,
//       body: body,
//       header: header,
//     );

//     log('policeStationResponseModel --- response>> $response');

//     PoliceStationResponseModel policeStationResponseModel =
//         PoliceStationResponseModel.fromJson(response);

//     log('policeStationResponseModel --- response>> $response');

//     return policeStationResponseModel;
//   }


//  Future<dynamic> getTimeSlot({Map<String, dynamic>? body}) async {
//     var response = await APIService().getResponse(
//       url: ApiRouts.getTimeSlot,
//       apiType: APIType.aGet,
//       body: body,
//       header: header,
//     );

//     log('timeSlotResponseModel --- response>> $response');

//     TimeSlotResponseModel timeSlotResponseModel =
//         TimeSlotResponseModel.fromJson(response);

//     log('timeSlotResponseModel --- response>> $response');

//     return timeSlotResponseModel;
//   }

// }
