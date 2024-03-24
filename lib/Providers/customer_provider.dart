import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../Models/customer_model.dart';

class CustomerProvider with ChangeNotifier {
  List<CustomerModel> _customers = [];

  List<CustomerModel> get customers => _customers;

  CustomerModel? _currentCustomer;
  CustomerModel? get currentCustomer => _currentCustomer;

  FirebaseFirestore fireInstance = FirebaseFirestore.instance;

  setCustomer(CustomerModel? customer){
    _currentCustomer = customer;
    notifyListeners();
  } 


   CustomerModel findById(String Id) {
    return _customers.firstWhere((customer) => customer.id == Id);
  }

    bool isNameAndPhoneNumberExists(String name, String phoneNumber) {
    // Iterate over the customers list and check if the provided name
    // and phone number match any existing customer's name and phone number.
    for (var customer in _customers) {
      if (customer.name == name && customer.phoneNum == phoneNumber) {
        return true; // Name and phone number match an existing customer
      }
    }
    return false; // Name and phone number do not match any existing customer
  }

    CustomerModel findByPhone(String phoneNo) {
    return _customers.firstWhere(
      (customer) => customer.phoneNum == phoneNo,
      orElse: () => throw Exception('Customer not found'),
    );
  }

  Future<void> addCustomer(CustomerModel customer) async {
    try {
      final collectionref = fireInstance.collection('Customers');
      final docRef = await collectionref.add({
        'name': customer.name,
        'address': customer.address,
        'apartment': customer.apartment,
        'city': customer.city,
        'zipCode': customer.zipCode,
        'phoneNum': customer.phoneNum,
        'email': customer.email,
      });

      _customers.add(CustomerModel(
          id: docRef.id,
          name: customer.name,
          address: customer.address,
          apartment: customer.apartment,
          city: customer.city,
          zipCode: customer.zipCode,
          phoneNum: customer.phoneNum,
          email: customer.email));

      notifyListeners();
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> updateCustomer(CustomerModel customer) async {
    try {
      final collectionref =
          fireInstance.collection('Customers').doc(customer.id);
      await collectionref.update({
        'name': customer.name,
        'address': customer.address,
        'apartment': customer.apartment,
        'city': customer.city,
        'zipCode': customer.zipCode,
        'phoneNum': customer.phoneNum,
        'email': customer.email,
      });

      final index =
          _customers.indexWhere((element) => element.id == customer.id);
      if (index >= 0) {
        _customers[index] = customer;
        notifyListeners();
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<List<CustomerModel>> fethDataByList(BuildContext context) async {
    try {
      final collectionref = fireInstance.collection('Customers');
      final response = await collectionref.get();

      final List<CustomerModel> temporary = [];
      for (var doc in response.docs) {
        final docData = doc.data();

        temporary.add(CustomerModel(
            id: doc.id,
            name: docData['name'],
            address: docData['address'],
            apartment: docData['apartment'],
            city: docData['city'],
            zipCode: docData['zipCode'],
            phoneNum: docData['phoneNum'],
            email: docData['email']));
      }
      _customers = temporary;

      notifyListeners();

      return temporary;
    } on Exception {
      rethrow;
    }
  }

  void clear() {
    _currentCustomer = null;
  }
}
