import 'dart:async';
import 'dart:convert';

import 'get_server_key.dart';
import 'package:http/http.dart' as http;

class SendNotificationService {
  static Future<void> sendNotificationUsingApi({
    required String? token,
    required String? title,
    required String? body,
    required Map<String, dynamic>? data,
  }) async {
    String serverKey = await GetServerKey().getServerKeyToken();
    print("notification server key => $serverKey");
    String url = "https://fcm.googleapis.com/v1/projects/pushnotifications-00001/messages:send";
    // String url = "https://www.google.com/";
    try{
    var headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $serverKey',
    };

    //mesaage
    Map<String, dynamic> message = {
      "message": {
        "token": token,
        "notification": {"body": body, "title": title},
        "data": data,
      }
    };

    //hit api
    // final stopwatch = Stopwatch()..start();
    final http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(message),
    ).timeout(Duration(seconds: 10));
    // stopwatch.stop();
    // print("sendusingapi took: ${stopwatch.elapsedMilliseconds}ms");
    if (response.statusCode == 200) {
      print("Notification Send Successfully!");
    } else {
      print("Notification not send!");
    }}
    on TimeoutException {
      print('FCM Request timed out');
    } catch (e, stack) {
      print('FCM Error: $e');
      print(stack);
    }

  }
}