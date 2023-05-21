import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_employee/view/profile/profile_page.dart';
import 'package:provider/provider.dart';
import '../../../viewmodel/user_model.dart';
import '../../model/domain/user.dart';
import 'auth_form_page.dart';

class MainProfilePage extends StatefulWidget {
  const MainProfilePage({super.key});

  @override
  State<MainProfilePage> createState() => _MainProfilePageState();
}

class _MainProfilePageState extends State<MainProfilePage> {
  GetIt getIt = GetIt.instance;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: Provider.of<UserModel>(context).getUser(),
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.data == null) {
          return const AuthFormPage();
        } else {
          return const ProfilePage();
        }
      },
    );
  }
}
