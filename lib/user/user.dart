class User {
  String image;
  String phone;
  String aboutMeDescription;

  // Constructor
  User({
    required this.image,
    required this.phone,
    required this.aboutMeDescription,
  });

  User copy({
    String? imagePath,
    String? name,
    String? phone,
    String? email,
    String? about,
  }) =>
      User(
        image: imagePath ?? this.image,
        phone: phone ?? this.phone,
        aboutMeDescription: about ?? this.aboutMeDescription,
      );

  static User fromJson(Map<String, dynamic> json) => User(
    image: json['imagePath'],
    aboutMeDescription: json['about'],
    phone: json['phone'],
  );

  Map<String, dynamic> toJson() => {
    'imagePath': image,
    'about': aboutMeDescription,
    'phone': phone,
  };
}