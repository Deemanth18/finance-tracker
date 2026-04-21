import 'package:flutter/material.dart';

import '../ui/components/fintech_components.dart';
import '../utils/helpers.dart';

class ExpenseScreen extends StatelessWidget {
  const ExpenseScreen({
    super.key,
    required this.expenses,
    required this.searchController,
    required this.filterCategory,
    required this.onFilterChanged,
    required this.onSearchChanged,
    required this.onAddExpense,
    required this.onDeleteExpense,
    required this.total,
    required this.topCategory,
  });

  final List expenses;
  final TextEditingController searchController;
  final String filterCategory;
  final ValueChanged<String> onFilterChanged;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onAddExpense;
  final Future<void> Function(String id) onDeleteExpense;
  final double total;
  final String topCategory;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 10, 28, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              _ExpenseMetricCard(
                title: 'Visible transactions',
                value: expenses.length.toString(),
                caption: 'Filtered expense rows currently in view',
                icon: Icons.list_alt_rounded,
                color: const Color(0xFF86EFAC),
              ),
              _ExpenseMetricCard(
                title: 'Filtered value',
                value: formatCurrency(total),
                caption: 'Running spend visible in the expense ledger',
                icon: Icons.payments_rounded,
                color: const Color(0xFF4ADE80),
              ),
              _ExpenseMetricCard(
                title: 'Leading category',
                value: topCategory,
                caption: 'Category with the highest concentration of spend',
                icon: Icons.local_fire_department_rounded,
                color: const Color(0xFF22C55E),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: panelDecoration(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Expense ledger',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                              color: FintechPalette.primaryTextFor(context),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Capture, filter, and review every business expense in one place.',
                            style: TextStyle(
                              color: FintechPalette.secondaryTextFor(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: onAddExpense,
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Add expense'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    SizedBox(
                      width: 340,
                      child: TextField(
                        controller: searchController,
                        onChanged: onSearchChanged,
                        decoration: const InputDecoration(
                          hintText: 'Search by amount or category',
                          prefixIcon: Icon(Icons.search_rounded),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 220,
                      child: DropdownButtonFormField<String>(
                        value: filterCategory,
                        items: const ['All', 'Food', 'Travel', 'Shopping', 'Other']
                            .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            onFilterChanged(value);
                          }
                        },
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.filter_alt_rounded),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                if (expenses.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark 
                          ? const Color(0xFF172133) 
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'No expenses match the current filters.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: FintechPalette.secondaryTextFor(context)),
                    ),
                  )
                else
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 760) {
                        return Column(
                          children: expenses.map((expense) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _ExpenseListCard(
                                expense: expense,
                                onDelete: () => onDeleteExpense(expense['id'].toString()),
                              ),
                            );
                          }).toList(),
                        );
                      }

                      return ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: DataTable(
                          columnSpacing: 32,
                          headingRowColor: MaterialStateProperty.all(
                            const Color(0x3322C55E),
                          ),
                          columns: const [
                            DataColumn(label: Text('Category')),
                            DataColumn(label: Text('Status')),
                            DataColumn(label: Text('Amount')),
                            DataColumn(label: Text('Action')),
                          ],
                          rows: expenses.map((expense) {
                            final category = expense['category']?.toString() ?? 'Other';
                            final amount = double.tryParse(expense['amount'].toString()) ?? 0;
                            final id = expense['id'].toString();
                            return DataRow(
                              cells: [
                                DataCell(
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 18,
                                        backgroundColor: categoryColor(category).withOpacity(0.14),
                                        child: Icon(
                                          categoryIcon(category),
                                          size: 18,
                                          color: categoryColor(category),
                                        ),
                                      ),
                                    const SizedBox(width: 12),
                                      Text(
                                        category,
                                        style: TextStyle(
                                          color: FintechPalette.primaryTextFor(context),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    'Captured',
                                    style: TextStyle(
                                      color: FintechPalette.secondaryTextFor(context),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    formatCurrency(amount),
                                    style: const TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ),
                                DataCell(
                                  IconButton(
                                    onPressed: () => onDeleteExpense(id),
                                    icon: const Icon(Icons.delete_outline_rounded),
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ExpenseFormSheet extends StatelessWidget {
  const ExpenseFormSheet({
    super.key,
    required this.amountController,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.onSubmit,
  });

  final TextEditingController amountController;
  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: FintechPalette.glassGradientFor(context),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: FintechPalette.strokeFor(context)),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add a new expense',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              'Log a transaction quickly without changing your API flow.',
              style: TextStyle(color: FintechPalette.secondaryTextFor(context)),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixIcon: Icon(Icons.currency_rupee_rounded),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              items: const ['Food', 'Travel', 'Shopping', 'Other']
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  onCategoryChanged(value);
                }
              },
              decoration: const InputDecoration(
                labelText: 'Category',
                prefixIcon: Icon(Icons.category_rounded),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onSubmit,
                child: const Text('Save expense'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BudgetSettingsSheet extends StatelessWidget {
  const BudgetSettingsSheet({
    super.key,
    required this.budgetController,
    required this.onSubmit,
  });

  final TextEditingController budgetController;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: FintechPalette.glassGradientFor(context),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: FintechPalette.strokeFor(context)),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Update budget',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: budgetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Monthly budget',
                prefixIcon: Icon(Icons.account_balance_wallet_rounded),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onSubmit,
                child: const Text('Save budget'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpenseMetricCard extends StatelessWidget {
  const _ExpenseMetricCard({
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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(22),
      decoration: panelDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: color.withOpacity(0.14),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 16),
          Text(title, style: TextStyle(color: FintechPalette.secondaryTextFor(context))),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 24,
              color: FintechPalette.primaryTextFor(context),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            caption,
            style: TextStyle(color: FintechPalette.mutedTextFor(context), height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _ExpenseListCard extends StatelessWidget {
  const _ExpenseListCard({
    required this.expense,
    required this.onDelete,
  });

  final dynamic expense;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final category = expense['category']?.toString() ?? 'Other';
    final amount = double.tryParse(expense['amount'].toString()) ?? 0;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: FintechPalette.glassGradientFor(context),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: FintechPalette.strokeFor(context)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: categoryColor(category).withOpacity(0.14),
            child: Icon(categoryIcon(category), color: categoryColor(category)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              category,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: FintechPalette.primaryTextFor(context),
              ),
            ),
          ),
          Text(
            formatCurrency(amount),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: FintechPalette.primaryTextFor(context),
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline_rounded),
            color: Colors.redAccent,
          ),
        ],
      ),
    );
  }
}

BoxDecoration panelDecoration(BuildContext context) {
  return BoxDecoration(
    gradient: LinearGradient(
      colors: FintechPalette.glassGradientFor(context),
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    border: Border.all(color: FintechPalette.strokeFor(context)),
    borderRadius: const BorderRadius.all(Radius.circular(28)),
    boxShadow: [
      BoxShadow(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0x22000000)
            : const Color(0x12072A1F),
        blurRadius: 20,
        offset: const Offset(0, 12),
      ),
    ],
  );
}
