// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:get/get.dart';
import 'package:greengrocer/src/models/cart_item_model.dart';

import 'package:greengrocer/src/models/order_model.dart';
import 'package:greengrocer/src/pages/auth/controller/auth_controller.dart';
import 'package:greengrocer/src/pages/orders/repository/orders_repository.dart';
import 'package:greengrocer/src/pages/orders/result/orders_result.dart';
import 'package:greengrocer/src/services/utils_services.dart';

class OrderController extends GetxController {
  OrderModel order;

  OrderController(
    this.order,
  );

  final OrdersRepository ordersRepository = OrdersRepository();
  final AuthController authController = Get.find<AuthController>();
  final UtilsServices utilsServices = UtilsServices();
  bool isLoading = false;

  void setLoading(bool value) {
    isLoading = value;
    update();
  }

  Future<void> getOrderItems() async {
    setLoading(true);
    final OrdersResult<List<CartItemModel>> result =
        await ordersRepository.getOrderItems(
      orderId: order.id,
      token: authController.userModel.token!,
    );
    setLoading(false);

    result.when(
      success: (items) {
        order.items = items;
        update();
      },
      error: (message) {
        utilsServices.showToast(
          message: message,
          isError: true,
        );
      },
    );
  }
}
