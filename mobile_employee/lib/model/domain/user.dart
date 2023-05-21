class User {
  final int id;
  final String name;
  final String phoneNumber;

  User({required this.id, required this.name, required this.phoneNumber});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'], name: json['name'], phoneNumber: json['phoneNumber']);
  }
}
