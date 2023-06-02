import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_employee/model/api/order_repository.dart';
import 'package:mobile_employee/view/qr/order/order_info.dart';
import 'package:mobile_employee/view/widgets/order_card.dart';

import '../model/domain/order_DTO.dart';

class OrderListPage extends StatefulWidget {
  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GetIt getIt = GetIt.instance;
  late Future<List<OrderDTO>> data;

  String _phoneNumber = '';

  @override
  void initState() {
    super.initState();
    data = getIt<OrderRepository>().getLastOrders();
  }

  Future<void> fetchData() async {
    var productsList = await getIt<OrderRepository>().getLastOrders();
    setState(() {
      data = Future.value(productsList);
    });
  }

  Future<void> searchByPhone(String phoneNumber) async {
    var orderList =
        await getIt<OrderRepository>().findOrderByNumber(phoneNumber);
    setState(() {
      data = Future.value(orderList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            fetchData();
          },
          child: FutureBuilder<List<OrderDTO>>(
            future: data,
            builder:
                (BuildContext context, AsyncSnapshot<List<OrderDTO>> snapshot) {
              if (snapshot.hasError) {
                if (snapshot.error == 'access denied') {
                  return const Center(
                      child: Text(
                    'Доступ запрещен. Войдите с аккаунта работника.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'PoiretOne',
                        fontSize: 32),
                  ));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                        child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 8,
                              child: Form(
                                  key: _formKey,
                                  child: TextFormField(

                                      decoration: const InputDecoration(
                                          labelStyle: TextStyle(
                                              fontFamily: 'PoiretOne',
                                              color: Color(0xFF3EB489),
                                              fontSize: 20),
                                          labelText: 'Телефон',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                          )),
                                      onChanged: (value) {
                                        setState(() {
                                          _phoneNumber = value;
                                        });
                                      },
                                      keyboardType: TextInputType.phone,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Пожалуйста, введите телефон';
                                        }
                                        String pattern = r'^\+?\d{10,11}$';
                                        RegExp regex = RegExp(pattern);
                                        if (!regex.hasMatch(value)) {
                                          return 'Введите корректный телефонный номер';
                                        }
                                        return null;
                                      }))),
                          Expanded(
                            child: IconButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    searchByPhone(_phoneNumber);
                                  }
                                },
                                icon: const Icon(
                                  Icons.search,
                                  size: 32,
                                )),
                          )
                        ],
                      ),
                    )),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                          childCount: snapshot.data!.length, (context, index) {
                        return Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                            child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OrderInfo(
                                              code: snapshot
                                                  .data![index].order.id
                                                  .toString())));
                                },
                                child:
                                    OrderCard(order: snapshot.data![index])));
                      }),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
