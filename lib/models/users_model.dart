class UserModel {
  String name;
  String email;
  String phone;
  String image;
  String cover;
  String bio;
  String uId;
  bool isEmailVerified;

  UserModel({
    this.name,
    this.email,
    this.phone,
    this.uId,
    this.isEmailVerified,
    this.image,
    this.bio,
    this.cover,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    image = json['image'];
    cover = json['cover'];
    bio = json['bio'];
    uId = json['uId'];
    isEmailVerified = json['isEmailVerified'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'image': image,
      'cover': cover,
      'bio': bio,
      'uId': uId,
      'isEmailVerified': isEmailVerified,
    };
  }
}
