import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kiosk_app/Models/kiosk_user.dart';

class KioskUserProvider with ChangeNotifier {
  List<KioskUser> _kioskUsers = [];

  List<KioskUser> get kioskUsers => _kioskUsers;

  KioskUser? _tempUser;

  KioskUser? get tempUser => _tempUser;

  // Function to add or update a KioskUser
  Future<void> addOrUpdateKioskUser(KioskUser kioskUser) async {
    try {
      // Check if the kioskUser exists in the local list
      int index;
      index = _kioskUsers.indexWhere(
        (user) => user.phoneNumber == kioskUser.phoneNumber,
      );

      if (index != -1) {
        // KioskUser with the same phone number exists locally, update the numberOfOrders property
        _kioskUsers[index].numberOfOrders += 1;

        // Update the number of orders on the backend (Firestore)
        await FirebaseFirestore.instance
            .collection('kioskUsers')
            .doc(_kioskUsers[index]
                .id) // Assuming phoneNumber is a unique identifier
            .update({
          'numberOfOrders': _kioskUsers[index].numberOfOrders,
        });
      } else {
        // KioskUser with the phone number doesn't exist locally, add a new one

        // Add to Firestore
        final response =
            await FirebaseFirestore.instance.collection('kioskUsers').add({
          'name': kioskUser.name,
          'email': kioskUser.email,
          'phoneNumber': kioskUser.phoneNumber,
          'numberOfOrders': kioskUser.numberOfOrders,
        });
        _kioskUsers.add(KioskUser(
          id: response.id,
          name: kioskUser.name,
          email: kioskUser.email,
          phoneNumber: kioskUser.phoneNumber,
          numberOfOrders: kioskUser.numberOfOrders,
        ));
      }

      notifyListeners();
    } catch (error) {
      // Handle errors as needed
      print('Error adding/updating kioskUser: $error');
    }
  }

  // Function to fetch all kioskUsers
  // Function to fetch all kioskUsers
  Future<void> fetchKioskUsers() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> result =
          await FirebaseFirestore.instance.collection('kioskUsers').get();

      _kioskUsers = result.docs.map((doc) {
        final data = doc.data();
        return KioskUser(
          id: doc.id,
          name: data['name'],
          email: data['email'],
          phoneNumber: data['phoneNumber'],
          numberOfOrders: data['numberOfOrders'],
        );
      }).toList();

      notifyListeners();
    } catch (error) {
      // Handle errors as needed
      print('Error fetching kioskUsers: $error');
    }
  }

  void setTempUser(kioskUser) {
    _tempUser = kioskUser;
    notifyListeners();
  }
}
