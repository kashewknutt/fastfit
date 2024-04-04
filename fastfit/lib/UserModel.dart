class UserModel {
  final String?  id;
  final String name;
  final double age;
  final double height;
  final double weight;
  final double phoneno;
  final String email;
  final String password;

  const UserModel({
    required this.id,
    required this.name,
    required this.age,
    required this.height,
    required this.weight,
    required this.phoneno,
    required this.email,
    required this.password,

  });

  toJson(){
    return {
      'id': id,
      'name': name,
      'age': age,
      'height': height,
      'weight': weight,
      'phoneno': phoneno,
      'email': email,
      'password': password,
    };
  }
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      age: json['age']?.toDouble() ?? 0.0,
      height: json['height']?.toDouble() ?? 0.0,
      weight: json['weight']?.toDouble() ?? 0.0,
      phoneno: json['phoneno']?.toDouble() ?? 0.0,
      email: json['email'],
      password: json['password'],
    );
  }
}