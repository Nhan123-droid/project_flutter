class User {
  int? id;
  String name;
  String email;
  String phone;
  String genDer;
  DateTime dateOfBirth;
  String password;
  String? avatarPath;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.genDer,
    required this.dateOfBirth,
    required this.password,
    this.avatarPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'genDer': genDer,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'password': password,
      'avatarPath': avatarPath,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      genDer: map['genDer'],
      dateOfBirth: DateTime.parse(map['dateOfBirth']),
      password: map['password'],
      avatarPath: map['avatarPath'],
    );
  }
}
