import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greengrocer/src/config/custom_colors.dart';
import 'package:greengrocer/src/models/cart_item_model.dart';
import 'package:greengrocer/src/pages/cart/controller/cart_controller.dart';
import 'package:greengrocer/src/pages/common_widgets/quantity_widget.dart';
import 'package:greengrocer/src/services/utils_services.dart';

class CartTile extends StatefulWidget {
  final CartItemModel cartItemModel;

  const CartTile({
    Key? key,
    required this.cartItemModel,
  }) : super(key: key);

  @override
  State<CartTile> createState() => _CartTileState();
}

class _CartTileState extends State<CartTile> {
  final UtilsServices utilsServices = UtilsServices();
  final controller = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: ListTile(
        // Imagem
        leading: Image.network(
          widget.cartItemModel.item.imgUrl,
          height: 60.0,
          width: 60.0,
        ),

        // Título
        title: Text(
          widget.cartItemModel.item.itemName,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),

        // Total
        subtitle: Text(
          utilsServices.priceToCurrency(
            widget.cartItemModel.totalPrice(),
          ),
          style: TextStyle(
            color: CustomColors.customSwatchColor,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Quantidade
        trailing: QuantityWidget(
          value: widget.cartItemModel.quantity,
          suffixText: widget.cartItemModel.item.unit,
          result: (quantity) {
            controller.changeItemQuantity(
              item: widget.cartItemModel,
              quantity: quantity,
            );
          },
          isRemovable: true,
        ),
      ),
    );
  }
}
