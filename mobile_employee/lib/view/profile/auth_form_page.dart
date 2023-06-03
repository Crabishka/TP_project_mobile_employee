import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../../app.dart';

import '../../../viewmodel/user_model.dart';

class AuthFormPage extends StatefulWidget {
  const AuthFormPage({super.key});

  @override
  State<AuthFormPage> createState() => _AuthFormPageState();
}

class _AuthFormPageState extends State<AuthFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool showPassword = false;
  String _phoneNumber = '';
  String _password = '';
  GetIt getIt = GetIt.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Image.asset(
                "./assets/images/ball.png",
                color: const Color(0xFF3EB489),
                height: 80,
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                "Добро пожаловать в Sportique",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,

                    fontWeight: FontWeight.bold),
              ),
              const Text(
                "Войдите или зарегистрируйтесь, чтобы продолжить",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, ),
              ),
              Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(32, 40, 32, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: TextFormField(
                            decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.phone_iphone_sharp),
                                labelStyle: TextStyle(

                                    color: const Color(0xFF3EB489),
                                    fontSize: 20),
                                labelText: 'Номер Телефона',
                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                                )),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Пожалуйста, введите ваш телефон';
                              }
                              String pattern = r'^\+?\d{10,11}$';
                              RegExp regex = RegExp(pattern);
                              if (!regex.hasMatch(value)) {
                                return 'Введите корректный телефонный номер';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                _phoneNumber = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: TextFormField(
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.password),
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        showPassword = !showPassword;
                                      });
                                    },
                                    icon: Icon(Icons.remove_red_eye_outlined)),
                                labelStyle: const TextStyle(

                                    color: Color(0xFF3EB489),
                                    fontSize: 20),
                                labelText: 'Пароль',
                                border: const OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                                )),
                            obscureText: !showPassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Пожалуйста, введите ваш пароль';
                              }

                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                _password = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Column(
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: const Color(0xFF3EB489),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(5))),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    Provider.of<UserModel>(context,
                                        listen: false)
                                        .authUser(_phoneNumber, _password)
                                        .then((value) {
                                      App.changeIndex(2);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => App()));
                                    }).catchError((_) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(_errorAuthBar());
                                    });
                                  }
                                },
                                child: Container(
                                  width:
                                  MediaQuery.of(context).size.width * 0.6,
                                  child: const Text(
                                    'Войти',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 24,

                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  SnackBar _errorAuthBar() {
    return SnackBar(
      duration: const Duration(seconds: 3),
      content: const Text(
          'Такой пользователь не найден или пароль не верен. Проверьте еще раз.'),
      action: SnackBarAction(
        label: 'Хорошо :(',
        onPressed: () {},
      ),
    );
  }
}
