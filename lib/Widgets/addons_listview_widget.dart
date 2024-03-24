// import 'package:flutter/material.dart';
// import 'package:kiosk_app/Models/Order_Item_Model.dart';
// import 'package:kiosk_app/Widgets/Show_Addons.dart';
// import 'package:kiosk_app/Widgets/custom_button.dart';
// import 'package:kiosk_app/Widgets/single_addon_widget.dart';
// import 'package:kiosk_app/constants.dart';

// class AddonsListviewWidget extends StatelessWidget {
//   const AddonsListviewWidget({super.key, required this.orderItem});
//   final OrderItemModel orderItem;

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return orderItem.addons.length <= 3
//         ? Container(
//             child: Column(
//               children: [
//                 ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: orderItem.addons.length,
//                   itemBuilder: (context, index) =>
//                       SingleAddonWidget(orderitem: orderItem, index: index),
//                 ),
//                 SizedBox(
//                   height: size.height * 0.01,
//                 ),
//                 CustomButton(
//                     onPressed: () {
//                       showDialog(
//                         context: context,
//                         builder: (context) => ShowAddonsWidget(
//                           saleitem: orderItem.item,
//                           isNew: false,
//                           itemQuantity: orderItem.quantity,
//                           existingAddons: orderItem.addons,
//                           index: ,
//                         ),
//                       );
//                     },
//                     borderColor: Colors.white,
//                     borderOn: false,
//                     borderRadius: size.height * 0.02,
//                     borderWidth: 0,
//                     color: Constants().primaryColor,
//                     height: size.height * 0.03,
//                     width: size.width * 0.25,
//                     child: Text(
//                       'Edit Item',
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: size.height * 0.02),
//                     ))
//               ],
//             ),
//           )
//         : Container(
//             height: size.height * 0.15,
//             child: Column(
//               children: [
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: orderItem.addons.length,
//                     itemBuilder: (context, index) =>
//                         SingleAddonWidget(orderitem: orderItem, index: index),
//                   ),
//                 ),
//                 SizedBox(
//                   height: size.height * 0.01,
//                 ),
//                 CustomButton(
//                     onPressed: () {
//                       showDialog(
//                         context: context,
//                         builder: (context) => ShowAddonsWidget(
//                           saleitem: orderItem.item,
//                           isNew: false,
//                           itemQuantity: orderItem.quantity,
//                           existingAddons: orderItem.addons,
//                         ),
//                       );
//                     },
//                     borderColor: Colors.white,
//                     borderOn: false,
//                     borderRadius: size.height * 0.02,
//                     borderWidth: 0,
//                     color: Constants().primaryColor,
//                     height: size.height * 0.03,
//                     width: size.width * 0.25,
//                     child: Text(
//                       'Edit Item',
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: size.height * 0.02),
//                     ))
//               ],
//             ),
//           );
//   }
// }
