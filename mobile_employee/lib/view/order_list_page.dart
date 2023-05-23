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
  GetIt getIt = GetIt.instance;
  late Future<List<OrderDTO>> data;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB6CFD8),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            fetchData();
          },
          child: FutureBuilder<List<OrderDTO>>(
            future: data,
            builder:
                (BuildContext context, AsyncSnapshot<List<OrderDTO>> snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                if (snapshot.error == 'access denied') {
                  return const Center(
                      child: Text(
                          'Доступ запрещен. Войдите с аккаунта работника.'));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              } else {
                return CustomScrollView(
                  slivers: [
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
                                                  .data![index].order.id.toString())));
                                },
                                child: OrderCard(
                                    order: snapshot.data![index].order)));
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
