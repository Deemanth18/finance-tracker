List filterExpenses(List expenses, String query, String category) {
  final normalizedQuery = query.trim().toLowerCase();

  return expenses.where((item) {
    final amount = item['amount'].toString().toLowerCase();
    final cat = (item['category'] ?? 'Other').toString();

    final matchesSearch = normalizedQuery.isEmpty ||
        amount.contains(normalizedQuery) ||
        cat.toLowerCase().contains(normalizedQuery);
    final matchesCategory = category == 'All' || cat == category;

    return matchesSearch && matchesCategory;
  }).toList();
}
