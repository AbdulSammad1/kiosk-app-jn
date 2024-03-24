import 'package:kiosk_app/Models/customer_model.dart';

import '../Models/Order_Item_Model.dart';

class OrderModel {
  final String id;
  final String employeeName;
  final CustomerModel customer;
  final List<OrderItemModel> orderItems;
  final String orderType;
  final String orderClassification;
  final String remarks;
  final DateTime date;
  final DateTime completeTime;
  final String orderNumber;
  final num loyaltyPoints;
  final num loyaltyMoney;
  final String status;
  final num totalPrice;
  OrderModel(
      {required this.id,
      required this.customer,
      required this.employeeName,
      required this.orderItems,
      required this.orderType,
      required this.orderClassification,
      required this.remarks,
      required this.date,
      required this.completeTime,
      required this.orderNumber,
      required this.status,
      required this.loyaltyMoney,
      required this.loyaltyPoints,
    
      required this.totalPrice});
}
