import 'package:booksphere_app/core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';

class CategoryPlaceholderScreen extends StatelessWidget {
  const CategoryPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(context.l10n.categoryScreenPlaceholder));
  }
}
