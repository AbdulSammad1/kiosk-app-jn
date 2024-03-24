class KioskUser {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  num numberOfOrders;

  KioskUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.numberOfOrders,
  });
}
