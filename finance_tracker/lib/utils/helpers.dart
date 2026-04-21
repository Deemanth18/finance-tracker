import 'package:flutter/material.dart';

double getTotal(List expenses) {
  double total = 0;
  for (var item in expenses) {
    total += double.tryParse(item['amount'].toString()) ?? 0;
  }
  return total;
}

Map<String, double> getCategoryData(List expenses) {
  Map<String, double> data = {};
  for (var item in expenses) {
    String cat = item['category'] ?? "Other";
    double amount = double.tryParse(item['amount'].toString()) ?? 0;

    data[cat] = (data[cat] ?? 0) + amount;
  }
  return data;
}

String formatCurrency(num value) {
  return 'Rs ${value.toStringAsFixed(0)}';
}

String getTopCategory(Map<String, double> categoryData) {
  if (categoryData.isEmpty) return 'No data';

  final entries = categoryData.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  return entries.first.key;
}

class SummaryCardData {
  const SummaryCardData({
    required this.title,
    required this.value,
    required this.caption,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final String caption;
  final IconData icon;
  final Color color;
}

List<SummaryCardData> buildSummaryCards(
  double total,
  double budget,
  Map<String, double> categoryData,
) {
  final topCategory = getTopCategory(categoryData);

  return [
    const SummaryCardData(
      title: 'Budget target',
      value: '',
      caption: 'Customer-configured monthly spend ceiling',
      icon: Icons.account_balance_wallet_rounded,
      color: Color(0xFF5B21B6),
    ),
    SummaryCardData(
      title: 'Top category',
      value: topCategory,
      caption: 'Highest spend category based on current records',
      icon: Icons.insights_rounded,
      color: const Color(0xFF0F766E),
    ),
    SummaryCardData(
      title: 'Expense velocity',
      value: formatCurrency(total / (categoryData.isEmpty ? 1 : categoryData.length)),
      caption: 'Average spend per active category',
      icon: Icons.speed_rounded,
      color: const Color(0xFFB45309),
    ),
  ].map((item) {
    if (item.title == 'Budget target') {
      return SummaryCardData(
        title: item.title,
        value: formatCurrency(budget),
        caption: item.caption,
        icon: item.icon,
        color: item.color,
      );
    }
    return item;
  }).toList();
}

IconData categoryIcon(String category) {
  switch (category) {
    case 'Food':
      return Icons.fastfood_rounded;
    case 'Travel':
      return Icons.flight_takeoff_rounded;
    case 'Shopping':
      return Icons.shopping_bag_rounded;
    default:
      return Icons.payments_rounded;
  }
}

Color categoryColor(String category) {
  switch (category) {
    case 'Food':
      return const Color(0xFFF97316);
    case 'Travel':
      return const Color(0xFF0EA5E9);
    case 'Shopping':
      return const Color(0xFF8B5CF6);
    default:
      return const Color(0xFF64748B);
  }
}
