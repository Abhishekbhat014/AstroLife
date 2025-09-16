class User {
  final int? userId; // User_ID (PK, AUTOINCREMENT)
  final String firstName; // First_Name
  final String? middleName; // Middle_Name (nullable)
  final String lastName; // Last_Name
  final String? motherName; // Mother_Name (nullable)
  final int gender; // Gender (0=Male, 1=Female, 2=Other maybe)
  final String dob; // DOB (stored as TEXT)
  final String? birthPlace; // Birth_Place (nullable)
  final String? address; // Address (nullable)
  final String email; // Email (UNIQUE)
  final String password; // Password (hashed)
  final String? contact; // Contact (nullable)
  final int roleId; // Role_ID (FK)
  final String? createdAt; // Created_At (default CURRENT_TIMESTAMP)

  User({
    this.userId,
    required this.firstName,
    this.middleName,
    required this.lastName,
    this.motherName,
    required this.gender,
    required this.dob,
    this.birthPlace,
    this.address,
    required this.email,
    required this.password,
    this.contact,
    required this.roleId,
    this.createdAt,
  });

  /// Convert User → Map (for insert/update)
  Map<String, dynamic> toMap() {
    return {
      'User_ID': userId,
      'First_Name': firstName,
      'Middle_Name': middleName,
      'Last_Name': lastName,
      'Mother_Name': motherName,
      'Gender': gender,
      'DOB': dob,
      'Birth_Place': birthPlace,
      'Address': address,
      'Email': email,
      'Password': password,
      'Contact': contact,
      'Role_ID': roleId,
      'Created_At': createdAt,
    };
  }

  /// Convert Map → User (for fetching from DB)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['User_ID'],
      firstName: map['First_Name'],
      middleName: map['Middle_Name'],
      lastName: map['Last_Name'],
      motherName: map['Mother_Name'],
      gender: map['Gender'],
      dob: map['DOB'],
      birthPlace: map['Birth_Place'],
      address: map['Address'],
      email: map['Email'],
      password: map['Password'],
      contact: map['Contact'],
      roleId: map['Role_ID'],
      createdAt: map['Created_At'],
    );
  }
}
