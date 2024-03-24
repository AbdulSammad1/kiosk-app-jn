import 'package:flutter/material.dart';
import 'package:kiosk_app/Providers/printer_provider.dart';
import 'package:kiosk_app/Widgets/printer_class.dart';
import 'package:provider/provider.dart';

class AvailablePrinters extends StatefulWidget {
  const AvailablePrinters({super.key});

  @override
  State<AvailablePrinters> createState() => _AvailablePrintersState();
}

class _AvailablePrintersState extends State<AvailablePrinters> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final printerProvider =
        Provider.of<PrinterProvider>(context, listen: false);
    return AlertDialog(
        title: Text('Available Devices',
            style: TextStyle(fontSize: size.height * 0.03)),
        content: SizedBox(
          height: size.height * 0.5,
          width: size.width * 0.6,
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: printerProvider.printers
                    .map((e) => ListTile(
                          title: Text('Name: ${e.name}'),
                          // trailing: Text('address: ${e.address}'),
                          selected: PrinterClass.selectedPrinterInfo != null &&
                              PrinterClass.selectedPrinterInfo!.ip == e.ip,
                          subtitle: Text('Ip: ${e.ip}'),
                          selectedColor: Colors.green.withOpacity(0.3),
                          onTap: () async {
                            PrinterClass.connect(e);
                            setState(() {});
                          },
                        ))
                    .toList()),
          ),
        ));
  }
}
