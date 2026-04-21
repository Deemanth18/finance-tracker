import 'dart:math';

String getAIInsight(List expenses, double budget) {
  if (expenses.isEmpty) {
    return 'Start tracking expenses to unlock tailored insights.';
  }

  final Map<String, double> data = {};

  for (final item in expenses) {
    final cat = item['category'] ?? 'Other';
    final amount = double.tryParse(item['amount'].toString()) ?? 0;
    data[cat] = (data[cat] ?? 0) + amount;
  }

  var topCategory = data.keys.first;
  var maxAmount = data[topCategory]!;

  data.forEach((key, value) {
    if (value > maxAmount) {
      maxAmount = value;
      topCategory = key;
    }
  });

  final total = data.values.fold<double>(0, (a, b) => a + b);

  if (total > budget) {
    return 'You are overspending. Review $topCategory transactions first.';
  }

  if (maxAmount > total * 0.5) {
    return 'Most of the current budget is going to $topCategory.';
  }

  return 'Your spending mix looks balanced across categories.';
}

String getPrediction(List expenses) {
  if (expenses.isEmpty) return 'No prediction available';

  var total = 0.0;

  for (final item in expenses) {
    total += double.tryParse(item['amount'].toString()) ?? 0;
  }

  final days = max(expenses.length, 1);
  final avgPerDay = total / days;
  final predictedMonthly = avgPerDay * 30;

  return 'At this rate, projected monthly spending is Rs ${predictedMonthly.toStringAsFixed(0)}.';
}
