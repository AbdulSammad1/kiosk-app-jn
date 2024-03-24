import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:intl/intl.dart';
import 'package:kiosk_app/Models/Order_Item_Model.dart';
import 'package:kiosk_app/Models/Order_Model.dart';
import 'package:kiosk_app/Models/printer_model.dart';

class PrinterClass {
  static PrinterModel? selectedPrinterInfo;

  static NetworkPrinter? selectedPrinter;

  num orderItemTotal(OrderItemModel orderItem) {
    num total = 0;

    total += orderItem.item.kioskData.discounted &&
            orderItem.item.kioskData.discountedPrice > 0
        ? (orderItem.item.kioskData.discountedPrice * orderItem.quantity)
        : (orderItem.item.salePrice * orderItem.quantity);

    for (final item in orderItem.addons) {
      total += orderItem.quantity * item.quantity * item.salePrice;
    }

    print('total is: $total');
    // for (final item in order.orderItems[order.orderItems.length].addons) {
    //   total += _orderItems[index].quantity * item.quantity * item.salePrice;
    // }
    // _orderItems[index].totalPrice = total;
    return total;
  }

  static Future<void> printReceipt(OrderModel order) async {
    PaperSize paper = selectedPrinterInfo?.paperWidth == '58mm'
        ? PaperSize.mm58
        : PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);

    try {
      final PosPrintResult res = await printer
          .connect(selectedPrinterInfo?.ip ?? '192.168.10.1', port: 9100);

      if (res == PosPrintResult.success) {
        print('Successful');
        printFunction(printer, order);
        printer.disconnect();
      } else {
        print('UnSuccessful');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  static void printFunction(NetworkPrinter printer, OrderModel order) {
    // printer.text('-----------------------------------------------');

    printer.row([
      PosColumn(width: 4),
      PosColumn(
        text: 'LOGO',
        width: 3,
        styles: const PosStyles(
          bold: true,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
      ),
      PosColumn(width: 5)
    ]);
    // printer.text('Kiosk Receipt',
    //     styles: const PosStyles(
    //         height: PosTextSize.size2,
    //         width: PosTextSize.size2,
    //         align: PosAlign.right));

    printer.emptyLines(1);

    printer.text('Order No: ${order.orderNumber}',
        styles: const PosStyles(bold: true));

    printer.text(
        'Date: ${DateFormat('h:mm:ss a dd/MM/yyyy').format(DateTime.now())}');
    printer.row([
      PosColumn(text: '-', width: 1),
      PosColumn(text: '-', width: 1),
      PosColumn(text: '-', width: 1),
      PosColumn(text: '-', width: 1),
      PosColumn(text: '-', width: 1),
      PosColumn(text: '-', width: 1),
      PosColumn(text: '-', width: 1),
      PosColumn(text: '-', width: 1),
      PosColumn(text: '-', width: 1),
      PosColumn(text: '-', width: 1),
      PosColumn(text: '-', width: 2),
      // PosColumn(text: '-', width: 1),
    ]);
    printer.row([
      PosColumn(text: 'Qty', styles: const PosStyles(bold: true)),
      PosColumn(text: 'Item', width: 4, styles: const PosStyles(bold: true)),
      PosColumn(width: 3),
      PosColumn(text: 'Price', width: 3, styles: const PosStyles(bold: true))
    ]);

    printer.row([
      PosColumn(text: '-', width: 1),
      PosColumn(text: '-', width: 1),
      PosColumn(text: '-', width: 1),
      PosColumn(text: '-', width: 1),
      PosColumn(text: '-', width: 1),
      PosColumn(text: '-', width: 1),
      PosColumn(text: '-', width: 1),
      PosColumn(text: '-', width: 1),
      PosColumn(text: '-', width: 1),
      PosColumn(text: '-', width: 1),
      PosColumn(text: '-', width: 2),
      // PosColumn(text: '-', width: 1),
    ]);
    for (final orderItem in order.orderItems) {
      print('total is ${PrinterClass().orderItemTotal(orderItem)}');
      printer.row([
        PosColumn(
          text: '${orderItem.quantity.toStringAsFixed(0)}x',
        ),
        PosColumn(text: orderItem.item.title, width: 4),
        PosColumn(width: 3),
        PosColumn(
            text: '\$${PrinterClass().orderItemTotal(orderItem)}', width: 3)
      ]);
    }

    printer.row([
      PosColumn(text: '-', width: 1),
      PosColumn(text: '-', width: 1),
      PosColumn(text: '-', width: 1),
      PosColumn(text: '-', width: 1),
      PosColumn(text: '-', width: 1),
      PosColumn(text: '-', width: 1),
      PosColumn(text: '-', width: 1),
      PosColumn(text: '-', width: 1),
      PosColumn(text: '-', width: 1),
      PosColumn(text: '-', width: 1),
      PosColumn(text: '-', width: 2),
      // PosColumn(text: '-', width: 1),
    ]);

    printer.emptyLines(1);

    printer.row([
      PosColumn(text: 'Total', styles: const PosStyles(bold: true)),
      PosColumn(width: 4, styles: const PosStyles(bold: true)),
      PosColumn(width: 3),
      PosColumn(
          text: order.totalPrice.toString(),
          width: 3,
          styles: const PosStyles(bold: true))
    ]);

    // printer.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ',
    //     styles: const PosStyles(codeTable: 'CP1252'));
    // printer
    //     .text('Special 2: blåbærgrød', styles: const PosStyles(codeTable: 'CP1252'));

    // printer.text('Bold text', styles: const PosStyles(bold: true));
    // printer.text('Reverse text', styles: const PosStyles(reverse: true));
    // printer.text('Underlined text',
    //     styles: const PosStyles(underline: true), linesAfter: 1);
    // printer
    //     .text('Align left', styles: const PosStyles(align: PosAlign.left));
    // printer
    //     .text('Align center', styles: const PosStyles(align: PosAlign.center));
    // printer.text('Align right',
    //     styles: const PosStyles(align: PosAlign.right), linesAfter: 1);

    printer.feed(2);
    printer.cut();
  }

  static void connect(PrinterModel printer) {
    selectedPrinterInfo = PrinterModel(
        id: printer.id,
        name: printer.name,
        ip: printer.ip,
        paperWidth: printer.paperWidth);
  }
}
