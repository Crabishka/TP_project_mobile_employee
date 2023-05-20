import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenHelper {
  final storage = const FlutterSecureStorage();

  Future<String?> getUserToken() async {
    String? token = await storage.read(key: 'jwt_token');
    return token;
  }

  Future<void> setUserToken({required String userToken}) async {
    await storage.write(key: 'jwt_token', value: userToken);
  }

  bool isTokenExpired(String token) {
    List<String> tokenParts = token.split('.');

    if (tokenParts.length != 3) {
      return true;
    }

    String payloadBase64 = tokenParts[1];

    String decodedPayload = utf8.decode(base64Url.decode(base64.normalize(payloadBase64)));
    Map<String, dynamic> payload = json.decode(decodedPayload);

    if (payload.containsKey('exp')) {
      int expirationTime = payload['exp'];
      int currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      if (expirationTime < currentTime) {
        return true;
      }
    }

    return false;
  }
}
