import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:kiosk_app/Models/printer_model.dart';

class PrinterProvider with ChangeNotifier {
  List<PrinterModel> _printers = [];

  List<PrinterModel> get printers => _printers;

  final collectionRef = FirebaseFirestore.instance.collection('Printers');

  Future<void> addPrinter(PrinterModel printer) async {
    try {
      final respnse = await collectionRef.add({
        'name': printer.name,
        'ip': printer.ip,
        'paperWidth': printer.paperWidth
      });
      _printers.add(PrinterModel(
          id: respnse.id,
          name: printer.name,
          ip: printer.ip,
          paperWidth: printer.paperWidth));
      notifyListeners();
    } on Exception {
      // TODO
    }
  }

  Future<void> fetchPrinters() async {
    try {
      final resopnse = await collectionRef.get();
      List<PrinterModel> temp = [];
      for (var doc in resopnse.docs) {
        final docData = doc.data();
        temp.add(PrinterModel(
            id: doc.id,
            name: docData['name'],
            ip: docData['ip'],
            paperWidth: docData['paperWidth']));
      }

      _printers = temp;
      notifyListeners();
    } on Exception {
      // TODO
    }
  }

  Future<void> updatePrinter(PrinterModel newPrinter) async {
    try {
      final respnse = await collectionRef.doc(newPrinter.id).update({
        'name': newPrinter.name,
        'ip': newPrinter.ip,
        'paperWidth': newPrinter.paperWidth
      });
      int index =
          _printers.indexWhere((element) => element.ip == newPrinter.ip);

      _printers[index] = (PrinterModel(
          id: newPrinter.id,
          name: newPrinter.name,
          ip: newPrinter.ip,
          paperWidth: newPrinter.paperWidth));
      notifyListeners();
    } on Exception {
      // TODO
    }
  }

  Future<void> delete(String id) async {
    await collectionRef.doc(id).delete();
    notifyListeners();
  }

  bool canCreate(String ip) {
    bool notFound = true;

    for (final printer in _printers) {
      if (printer.ip == ip) {
        notFound = false;
        return notFound;
      }
    }
    return notFound;
  }
}
