import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_employee/viewmodel/app_data.dart';
import 'package:mobile_employee/viewmodel/user_model.dart';

import 'package:provider/provider.dart';

import 'app.dart';
import 'model/api/user_repository.dart';


void main() {
  GetIt getIt = GetIt.instance;
  getIt.registerSingleton<AppData>(AppData());
  getIt.registerSingleton<UserRepository>(UserRepository());
  runApp(ChangeNotifierProvider(
    create: (context) => UserModel(),
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sportique',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: App(),
    );
  }
}
