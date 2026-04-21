import 'package:flutter/material.dart';

import '../ui/components/fintech_components.dart';
import '../utils/helpers.dart';
import 'expense_screen.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({
    super.key,
    required this.expenses,
    required this.total,
    required this.budget,
    required this.topCategory,
    required this.onExportPdf,
  });

  final List expenses;
  final double total;
  final double budget;
  final String topCategory;
  final VoidCallback onExportPdf;

  @override
  Widget build(BuildContext context) {
    final savings = budget - total;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 10, 28, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: const LinearGradient(
                colors: [Color(0xFF0D5A41), Color(0xFF22C55E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33169B52),
                  blurRadius: 24,
                  offset: Offset(0, 14),
                ),
              ],
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Export a polished finance report',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 28,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Generate a PDF snapshot of expenses for customers, managers, or month-end review.',
                        style: TextStyle(color: Color(0xFFDFF8E8), height: 1.5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: onExportPdf,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF0D5A41),
                  ),
                  icon: const Icon(Icons.download_rounded),
                  label: const Text('Export PDF'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              _ReportCard(
                title: 'Report summary',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ReportRow(label: 'Transactions', value: expenses.length.toString()),
                    _ReportRow(label: 'Total spent', value: formatCurrency(total)),
                    _ReportRow(label: 'Budget', value: formatCurrency(budget)),
                    _ReportRow(
                      label: 'Budget left',
                      value: formatCurrency(savings < 0 ? 0 : savings),
                    ),
                    _ReportRow(label: 'Top category', value: topCategory),
                  ],
                ),
              ),
              const _ReportCard(
                title: 'Included in export',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ChecklistItem('Expense list with amount and category'),
                    _ChecklistItem('Calculated monthly total'),
                    _ChecklistItem('Clean output for sharing or printing'),
                    _ChecklistItem('Uses the existing PDF export service unchanged'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 560,
      padding: const EdgeInsets.all(24),
      decoration: panelDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 20,
              color: FintechPalette.primaryTextFor(context),
            ),
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

class _ReportRow extends StatelessWidget {
  const _ReportRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: FintechPalette.secondaryTextFor(context))),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: FintechPalette.primaryTextFor(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChecklistItem extends StatelessWidget {
  const _ChecklistItem(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded, color: Color(0xFF4ADE80)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: FintechPalette.primaryTextFor(context)),
            ),
          ),
        ],
      ),
    );
  }
}
