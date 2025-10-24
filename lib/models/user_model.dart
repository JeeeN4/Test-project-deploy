class UserModel {
  final String name;
  final String gender;
  final String birthDate; 
  final double height;
  final double weight;
  final String activity;
  final String email;
  final String password;

  UserModel({
    required this.name,
    required this.gender,
    required this.birthDate,
    required this.height,
    required this.weight,
    required this.activity,
    required this.email,
    required this.password,
  });


  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'gender': gender,
      'birthDate': birthDate,
      'height': height,
      'weight': weight,
      'activity': activity,
      'email': email,
      'password': password,
    };
  }

  
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      gender: map['gender'] ?? '',
      birthDate: map['birthDate'] ?? '',
      height: (map['height'] ?? 0).toDouble(),
      weight: (map['weight'] ?? 0).toDouble(),
      activity: map['activity'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
    );
  }
}
