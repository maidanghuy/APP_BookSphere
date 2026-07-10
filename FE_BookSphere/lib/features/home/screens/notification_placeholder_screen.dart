import 'package:booksphere_app/core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';

class NotificationPlaceholderScreen extends StatelessWidget {
  const NotificationPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(context.l10n.notificationScreenPlaceholder));
  }
}
