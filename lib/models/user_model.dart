class UserModel {
  final String username;
  final String password;
  final String email;
  final dynamic image;
  final String intrestId;
  final String id;

  UserModel({
    required this.username,
    required this.password,
    required this.email,
    required this.image,
    required this.intrestId,
    required this.id,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        username: json['username'],
        password: json['password'],
        email: json['email'],
        image: json['image'],
        intrestId: json['intrestId'],
        id: json['id']);
  }
}
