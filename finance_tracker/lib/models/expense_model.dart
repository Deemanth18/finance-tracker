class Expense {
  String amount;
  String category;

  Expense({required this.amount, required this.category});

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      amount: json['amount'],
      category: json['category'] ?? "Other",
    );
  }
}
