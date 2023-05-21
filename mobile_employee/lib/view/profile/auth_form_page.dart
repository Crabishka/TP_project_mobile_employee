import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  String _phoneNumber = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB6CFD8),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 0, 8),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  labelStyle: TextStyle(
                                      fontFamily: 'PoiretOne',
                                      color: Color(0xFF342789),
                                      fontSize: 24),
                                  labelText: 'Teлефон',
                                  border: InputBorder.none),
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
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 0, 8),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  errorStyle: TextStyle(),
                                  labelStyle: TextStyle(
                                      fontFamily: 'PoiretOne',
                                      color: Color(0xFF342789),
                                      fontSize: 24),
                                  labelText: 'Пароль',
                                  border: InputBorder.none),
                              obscureText: true,
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
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Column(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15))),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  Provider.of<UserModel>(context, listen: false)
                                      .authUser(_phoneNumber, _password)
                                      .then((value) {
                                    App.changeIndex(2);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => App()));
                                  });
                                }
                              },
                              child: const Text(
                                'Войти',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'PoiretOne',
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
    );
  }
}
