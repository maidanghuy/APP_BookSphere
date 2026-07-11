enum BookAvailabilityFilter { all, available, unavailable }

/// Centralized search/filter state for Book List (BS-APP-14).
///
/// Availability is FE-only: backend `GET /api/books` supports `keyword` and
/// `categoryId` but does not expose an availability query parameter.
class BookFilter {
  const BookFilter({
    this.keyword = '',
    this.categoryId,
    this.availability = BookAvailabilityFilter.all,
  });

  final String keyword;
  final String? categoryId;
  final BookAvailabilityFilter availability;

  bool get hasKeyword => keyword.trim().isNotEmpty;

  bool get hasCategory => categoryId != null && categoryId!.trim().isNotEmpty;

  bool get hasAvailability => availability != BookAvailabilityFilter.all;

  bool get hasActiveFilters => hasKeyword || hasCategory || hasAvailability;

  bool get hasOnlyKeyword => hasKeyword && !hasCategory && !hasAvailability;

  bool get hasNonKeywordFilters => hasCategory || hasAvailability;

  BookFilter copyWith({
    String? keyword,
    String? categoryId,
    bool clearCategory = false,
    BookAvailabilityFilter? availability,
  }) {
    return BookFilter(
      keyword: keyword ?? this.keyword,
      categoryId: clearCategory ? null : categoryId ?? this.categoryId,
      availability: availability ?? this.availability,
    );
  }

  BookFilter cleared() => const BookFilter();

  @override
  bool operator ==(Object other) {
    return other is BookFilter &&
        other.keyword == keyword &&
        other.categoryId == categoryId &&
        other.availability == availability;
  }

  @override
  int get hashCode => Object.hash(keyword, categoryId, availability);
}
