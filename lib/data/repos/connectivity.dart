import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class Connectivity {
  static Future<bool> hasConnection() async {
    // Add the following code when backend is connected
    // try {
    //   final result = await InternetAddress.lookup('google.com');
    //   if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
    //     return true;
    //   }
    // } catch (e) {
    //   return false;
    // }
    print("No internet");
    return false;
  }

  Future<String> networkImageToBase64(String imageUrl) async {
    http.Response response = await http.get(imageUrl);
    final bytes = response?.bodyBytes;
    return (bytes != null ? base64Encode(bytes) : null);
  }
}
