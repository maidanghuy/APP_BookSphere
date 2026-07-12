/// BS-APP-24 – Profile data models

class ProfileResponse {
  const ProfileResponse({
    this.id,
    this.username,
    this.fullName,
    this.email,
    this.phone,
    this.role,
    this.isActive,
  });

  final String? id;
  final String? username;
  final String? fullName;
  final String? email;
  final String? phone;
  final String? role;
  final bool? isActive;

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'] as Map)
        : json;

    // role có thể là String hoặc List
    final rawRole = data['role'] ?? data['roles'];
    String? role;
    if (rawRole is List && rawRole.isNotEmpty) {
      role = rawRole.first.toString();
    } else if (rawRole != null) {
      role = rawRole.toString();
    }

    return ProfileResponse(
      id: data['id']?.toString(),
      username: data['username']?.toString(),
      fullName: data['fullName']?.toString() ?? data['full_name']?.toString(),
      email: data['email']?.toString(),
      phone: data['phone']?.toString(),
      role: role,
      isActive: data['isActive'] as bool? ?? data['active'] as bool?,
    );
  }
}
