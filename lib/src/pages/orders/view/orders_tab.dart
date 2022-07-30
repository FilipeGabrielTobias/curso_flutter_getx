import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greengrocer/src/pages/orders/controller/all_orders_controller.dart';
import 'package:greengrocer/src/pages/orders/view/components/order_tile.dart';

class OrdersTab extends StatelessWidget {
  const OrdersTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Pedidos',
        ),
      ),
      body: GetBuilder<AllOrdersController>(
        builder: (controller) {
          return RefreshIndicator(
            onRefresh: () => controller.getAllOrders(),
            child: ListView.separated(
              padding: const EdgeInsets.all(16.0),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (_, index) =>
                  OrderTile(order: controller.allOrders[index]),
              separatorBuilder: (_, index) => const SizedBox(
                height: 10.0,
              ),
              itemCount: controller.allOrders.length,
            ),
          );
        },
      ),
    );
  }
}
