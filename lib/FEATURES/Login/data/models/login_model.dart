class LoginResponseModel {
  final String access;
  final String refresh;
  final User user;

  LoginResponseModel({
    required this.access,
    required this.refresh,
    required this.user,
  });

  factory LoginResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return LoginResponseModel(
      access: json['access'],
      refresh: json['refresh'],
      user: User.fromJson(json['user']),
    );
  }
}

class User {
  final int id;
  final String role;
  final String email;
  final String phone;
  final String fieldStaffId;
  final String fieldStaffName;
  final int branchId;
  final String branchName;
  final String branchCode;

  User({
    required this.id,
    required this.role,
    required this.email,
    required this.phone,
    required this.fieldStaffId,
    required this.fieldStaffName,
    required this.branchId,
    required this.branchName,
    required this.branchCode,
  });

  factory User.fromJson(
    Map<String, dynamic> json,
  ) {
    return User(
      id: json['id'],
      role: json['role'],
      email: json['email'],
      phone: json['phone'],
      fieldStaffId: json['field_staff_id'],
      fieldStaffName: json['field_staff_name'],
      branchId: json['branch_id'],
      branchName: json['branch_name'],
      branchCode: json['branch_code'],
    );
  }
}