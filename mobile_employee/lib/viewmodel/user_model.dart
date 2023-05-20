import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

import '../model/api/user_repository.dart';
import '../model/domain/user.dart';

class UserModel extends ChangeNotifier {
  GetIt getIt = GetIt.instance;

  late User _user;

  Future<void> authUser(String phoneNumber, String password) async {
    await getIt.get<UserRepository>().authUser(phoneNumber, password);
    notifyListeners();
  }

  Future<User> getUser() async {
    _user = await getIt.get<UserRepository>().getUser();
    return _user;
  }

  Future<void> regUser(String phoneNumber, String password, String name) async {
    await getIt.get<UserRepository>().regUser(phoneNumber, password, name);
    notifyListeners();
  }
}
