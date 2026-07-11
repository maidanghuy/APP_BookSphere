enum AppNotificationType {
  borrow,
  returnBook,
  dueSoon,
  overdue,
  fine,
  payment,
  system,
  unknown,
}

class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.referenceId,
  });

  final int id;
  final String title;
  final String content;
  final AppNotificationType type;
  final bool isRead;
  final DateTime? createdAt;
  final int? referenceId;

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      type: parseNotificationType(json['type']?.toString()),
      isRead: json['isRead'] == true,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
      referenceId: (json['referenceId'] as num?)?.toInt(),
    );
  }

  AppNotification copyWith({bool? isRead}) => AppNotification(
    id: id,
    title: title,
    content: content,
    type: type,
    isRead: isRead ?? this.isRead,
    createdAt: createdAt,
    referenceId: referenceId,
  );
}

AppNotificationType parseNotificationType(String? value) => switch (value) {
  'BORROW' => AppNotificationType.borrow,
  'RETURN' => AppNotificationType.returnBook,
  'DUE_SOON' => AppNotificationType.dueSoon,
  'OVERDUE' => AppNotificationType.overdue,
  'FINE' => AppNotificationType.fine,
  'PAYMENT' => AppNotificationType.payment,
  'SYSTEM' => AppNotificationType.system,
  _ => AppNotificationType.unknown,
};
