import 'dart:convert';

import 'package:get_it/get_it.dart';

import '../../viewmodel/app_data.dart';
import '../../viewmodel/token_helper.dart';
import 'package:http/http.dart' as http;

import '../domain/user.dart';
import 'jwt_dto.dart';

class UserRepository {
  GetIt getIt = GetIt.instance;

  UserRepository() {
    mainUrl = getIt<AppData>().getUrl();
    urlForGetUser = "$mainUrl/users";
    urlForRegUser = "$mainUrl/users/registration";
    urlForAuthUser = "$mainUrl/users/login";
  }

  String mainUrl = "";
  String urlForGetUser = "";
  String urlForAuthUser = "";
  String urlForRegUser = "";

  Future<User> getUser() async {
    try {
      String? token = await TokenHelper().getUserToken();
      if (token == null ||
          token.isEmpty ||
          getIt.get<TokenHelper>().isTokenExpired(token)) {
        throw ('access denied');
      }
      final response = await http.get(Uri.parse(urlForGetUser), headers: {
        'Content-Type': 'application/json',
        'Authorization': token
      });
      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedJson = jsonDecode(response.body);
        User user = User.fromJson(decodedJson);
        return user;
      } else if (response.statusCode == 403) {
        throw ('Access denied');
      } else {
        throw Exception('Unexpected status code: ${response.statusCode}');
      }
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<void> authUser(String phoneNumber, String password) async {
    final response = await http.post(Uri.parse(urlForAuthUser),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "username": phoneNumber,
          "password": password,
        }));
    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedJson = jsonDecode(response.body);
      JwtDTO jwtDTO = JwtDTO.fromJson(decodedJson);
      TokenHelper().setUserToken(userToken: jwtDTO.accessToken);
    } else {}
  }

  Future<void> regUser(String phoneNumber, String password, String name) async {
    final response = await http.post(Uri.parse(urlForRegUser),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            {"phoneNumber": phoneNumber, "password": password, "name": name}));

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedJson = jsonDecode(response.body);
      JwtDTO jwtDTO = JwtDTO.fromJson(decodedJson);
      TokenHelper().setUserToken(userToken: jwtDTO.accessToken);
    } else {}
  }

  logout() {
    TokenHelper().setUserToken(userToken: '');
  }
}
