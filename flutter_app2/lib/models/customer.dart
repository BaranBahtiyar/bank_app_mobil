class Customer{

  int? id;
  String name;
  String dateOfBirth;
  double balance;

  Customer({this.id, required this.name, required this.dateOfBirth, required this.balance});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dateOfBirth': dateOfBirth,
      'balance': balance,
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'],
      dateOfBirth: map['dateOfBirth'],
      balance: map['balance'],
    );
  }

}
