/// Represents one locally-saved logged-in account.
/// Multiple of these are stored under AppPreferences.savedAccountsKey.
class AccountModel {
  final String userId; // stringified backend user id — primary uniqueness key
  final String name;
  final String email;
  final String accessToken;
  final String refreshToken;
  final Map<String, dynamic> userData; // full raw user payload (role, branch, etc.)

  const AccountModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.accessToken,
    required this.refreshToken,
    required this.userData,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      userId: json['userId'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      userData: Map<String, dynamic>.from(json['userData'] as Map),
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'name': name,
        'email': email,
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'userData': userData,
      };

  AccountModel copyWith({String? accessToken, String? refreshToken}) {
    return AccountModel(
      userId: userId,
      name: name,
      email: email,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      userData: userData,
    );
  }

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return 'U';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }
}