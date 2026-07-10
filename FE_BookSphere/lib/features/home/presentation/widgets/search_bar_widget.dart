import 'package:booksphere_app/core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({
    required this.controller,
    required this.onSubmitted,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  @override
  Widget build(BuildContext context) {
    return SearchBar(
      controller: widget.controller,
      hintText: context.l10n.searchBooks,
      leading: const Icon(Icons.search),
      trailing: [
        if (widget.controller.text.isNotEmpty)
          IconButton(
            tooltip: context.l10n.clearSearch,
            onPressed: () {
              widget.controller.clear();
              setState(() {});
            },
            icon: const Icon(Icons.clear),
          ),
      ],
      onChanged: (value) => setState(() {}),
      onSubmitted: widget.onSubmitted,
    );
  }
}
