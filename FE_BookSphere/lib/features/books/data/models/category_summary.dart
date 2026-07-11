String _idToString(Object? value) {
  if (value == null) {
    return '';
  }
  return value.toString();
}

/// Minimal category model for book list filters (`CategoryResponse`).
class CategorySummary {
  const CategorySummary({
    required this.id,
    required this.name,
    this.description,
    this.isActive,
  });

  final String id;
  final String name;
  final String? description;
  final bool? isActive;

  factory CategorySummary.fromJson(Map<String, dynamic> json) {
    final name = json['name']?.toString().trim();
    return CategorySummary(
      id: _idToString(json['id']),
      name: (name == null || name.isEmpty) ? '' : name,
      description: json['description']?.toString(),
      isActive: json['isActive'] is bool
          ? json['isActive'] as bool
          : json['isActive']?.toString().toLowerCase() == 'true'
          ? true
          : json['isActive']?.toString().toLowerCase() == 'false'
          ? false
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'isActive': isActive,
    };
  }
}
