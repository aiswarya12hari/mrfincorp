class ProfileModel {
  final int id;
  final String role;
  final String email;
  final String phone;
  final String fieldStaffId;
  final String fieldStaffName;
  final int branchId;
  final String branchName;
  final String branchCode;
  final String address;

  ProfileModel({
    required this.id,
    required this.role,
    required this.email,
    required this.phone,
    required this.fieldStaffId,
    required this.fieldStaffName,
    required this.branchId,
    required this.branchName,
    required this.branchCode,
    required this.address,
  });

  factory ProfileModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProfileModel(
      id: json['id'],
      role: json['role'],
      email: json['email'],
      phone: json['phone'],
      fieldStaffId: json['field_staff_id'],
      fieldStaffName: json['field_staff_name'],
      branchId: json['branch_id'],
      branchName: json['branch_name'],
      branchCode: json['branch_code'],
      address: json['address'] ?? '',
    );
  }
}