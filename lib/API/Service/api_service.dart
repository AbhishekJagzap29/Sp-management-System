import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:sp_manage_system/API/Apis/app_exception.dart';
import 'package:sp_manage_system/Screen/Constant/shared_prefs.dart';
import 'package:sp_manage_system/Screen/Utils/app_layout.dart';
import 'package:http/http.dart' as http;

enum APIType { aPost, aGet, aPut, aDelete, aFileUpload }

enum HeaderType {
  hAppJson,
  hUrlencoded,
}


class APIService {
  var response;

  Future getResponse({
    required String url,
    required APIType apiType,
    Map<String, dynamic>? body,
    Map<String, String>? header,
  }) async {
    log("url ===-----URL-----===>>>>> $url");
    try {
      if (apiType == APIType.aGet) {
        final result = await http.get(Uri.parse(url), headers: header);
        response = returnResponse(result.statusCode, result.body);
        log("res${result.body}");
      } else if (apiType == APIType.aPut) {
        log("REQUEST PARAMETER ======>>>>> ${jsonEncode(body)}");

        final result = await http.put(
          Uri.parse(url),
          body: body,
        
        );
        log("resp${result.body}");

        response = returnResponse(result.statusCode, result.body);
        log('result.statusCode===>${result.statusCode}');
      } else if (apiType == APIType.aDelete) {
        final result = await http.delete(Uri.parse(url), headers: header);
        response = returnResponse(result.statusCode, result.body);
        log("res${result.body}");
      } else if (apiType == APIType.aFileUpload) {
        var data = dio.FormData.fromMap(body!);

        var dio1 = dio.Dio();
        var result = await dio1.post(
          url,
          options: dio.Options(
            headers: header,
          ),
          data: data,
        );
        log('result.statusCode---------->>>>>> ${result.statusCode}');

        response = returnResponse(result.statusCode!, jsonEncode(result.data));
      } else {
        log("REQUEST PARAMETER ======>>>>> ${json.encode(body)}");

        final result = await http.post(Uri.parse(url),
            body: jsonEncode(body), headers: header);

        log("resp>>>>>result.statusCode>>>>>>${result.statusCode}");

        if (url.contains('login')) {
          if (result.statusCode == 403) {
            errorSnackBar(
                "Login Failed", "Please enter correct username and password");
          }
          log("resp>>>>>result.headers>>>>>>${result.headers}");
          String token = result.headers['set-cookie']!.split(";").first;
          preferences.putString(SharedPreference.sessionId, token);
          await Future.delayed(const Duration(milliseconds: 500));
        }

        response = returnResponse(result.statusCode, result.body);
      }
    } on SocketException {
      throw FetchDataException('No Internet access');
    }

    return response;
  }

  returnResponse(int status, String result) {
    switch (status) {
      case 200:
        return jsonDecode(result);
      case 201:
        return jsonDecode(result);
      case 204:
        return {
          "status": "SUCCESS",
          "message": "SuccessFully Query List Get",
          "data": []
        };
      case 400:
        throw BadRequestException('Bad Request');
      case 401:
        throw UnauthorisedException('Unauthorised user');
      case 403:
        throw UnauthorisedException('Unauthorised user');
      case 404:
        throw ServerException('Server Error');
      case 500:
      default:
        throw FetchDataException('Internal Server Error');
    }
  }

  authenticatedPost(String piStatusCount, Map<String, String> map, String sessionId) {}
}
