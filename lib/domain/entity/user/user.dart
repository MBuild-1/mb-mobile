class User {
  String id;
  String name;
  int role;
  String email;
  UserProfile userProfile;
  DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.role,
    required this.email,
    required this.userProfile,
    required this.createdAt
  });
}

class UserProfile {
  String id;
  String userId;
  String? provinceId;
  String? countryId;
  String? avatar;
  String? gender;
  DateTime? dateBirth;
  String? placeBirth;
  String? phoneNumber;
  String username;
  String? biography;

  UserProfile({
    required this.id,
    required this.userId,
    required this.provinceId,
    required this.countryId,
    required this.avatar,
    required this.gender,
    required this.dateBirth,
    required this.placeBirth,
    required this.phoneNumber,
    required this.username,
    required this.biography
  });
}

class NoUserProfile extends UserProfile {
  NoUserProfile() : super(
    id: "",
    userId: "",
    provinceId: null,
    countryId: null,
    username: "",
    avatar: null,
    gender: null,
    dateBirth: null,
    placeBirth: null,
    phoneNumber: null,
    biography: null
  );
}