import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminProvider with ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  int _kioskSliderItemsTimer = 0;
  int get kioskSliderItemsTimer => _kioskSliderItemsTimer;

  num _taxAmount = 0;
  num get taxAmount => _taxAmount; 

   Future<num> getTaxPercentage() async {
    try {
      final adminCollectionRef = _firestore.collection('Administrator');
      const docId = 'taxAmount';

      final docRef = await adminCollectionRef.doc(docId).get();

      if (!docRef.exists) {
        // Document does not exist, create it with default values
        await adminCollectionRef
            .doc(docId)
            .set({'taxAmount': 0.0}); // Set your default value here
        _taxAmount = 0.0; // Set your default value here
      } else {
        // Document exists, fetch and set the data
        num amount = docRef['taxAmount'];
        _taxAmount = amount;
      }

      return _taxAmount;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<int> fetchKioskSliderTimer() async {
    try {
      final adminCollectionRef = _firestore.collection('Administrator');
      final docRef = adminCollectionRef.doc('sliderTimers');
      final doc = await docRef.get();

      if (!doc.exists) {
        // Document does not exist, create it with default values
        await docRef.set({
          'customerDisplayItemsTimer': 4,
          'customerSliderItemsTimer': 4,
          'kioskSliderItemsTimer': 4, // Set your default value here
        });
        _kioskSliderItemsTimer = 4; // Set your default value here
      } else {
        // Document exists, fetch and set the data
        _kioskSliderItemsTimer = doc.data()!['kioskSliderItemsTimer'];
      }

      return _kioskSliderItemsTimer;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // New method to update kiosk slider timer
  Future<void> updateKioskSliderTimer(int time) async {
    final adminCollectionRef = _firestore.collection('Administrator');
    final docRef = adminCollectionRef.doc('sliderTimers');
    await docRef.update({'kioskSliderItemsTimer': time});
    _kioskSliderItemsTimer = time;
    notifyListeners();
  }


  Future<String> checkValid() async {
    final url = Uri.parse('https://ecomapp-eac82-default-rtdb.firebaseio.com/Validation.json');


    try {
      final favoriteResponse =
        await http.get(url, headers: {"Access-Control-Allow-Origin": "*"});
    final favoriteData =
        json.decode(favoriteResponse.body);

    print(favoriteData['kiosk']);

    return favoriteData['kiosk'];
    } catch (e) {
      print(e);
      rethrow;
    }
    
  }
}
