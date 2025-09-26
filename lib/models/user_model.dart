class User {
  int? userId;
  String firstName;
  String? middleName; // Added from ERD
  String lastName;
  String email;
  String password;
  String contact; // Added from ERD
  String address; // Added from ERD
  String birthDate; // Stored as DOB string
  String birthTime;
  String gender;
  String? profilePictureUrl;
  bool isActive;
  DateTime createdAt;
  DateTime updatedAt;

  User({
    this.userId,
    required this.firstName,
    this.middleName, // Optional
    required this.lastName,
    required this.email,
    required this.password,
    required this.contact,
    this.address = "",
    required this.birthDate,
    required this.birthTime,
    required this.gender,
    this.profilePictureUrl,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert a User object into a Map for SQLite.
  Map<String, dynamic> toSqlite() {
    return {
      'userId': userId,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'contact': contact,
      'address': address,
      'birthDate': birthDate,
      'birthTime': birthTime,
      'gender': gender,
      'profilePictureUrl': profilePictureUrl,
      'isActive': isActive ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Convert a Map from SQLite into a User object.
  static User fromSqlite(Map<String, dynamic> map) {
    return User(
      userId: map['userId'],
      firstName: map['firstName'],
      middleName: map['middleName'],
      lastName: map['lastName'],
      email: map['email'],
      password: map['password'],
      contact: map['contact'],
      address: map['address'],
      birthDate: map['birthDate'],
      birthTime: map['birthTime'],
      gender: map['gender'],
      profilePictureUrl: map['profilePictureUrl'],
      isActive: map['isActive'] == 1,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }
}
