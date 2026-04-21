import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../ui/components/fintech_components.dart';
import '../utils/helpers.dart';
import 'expense_screen.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({
    super.key,
    required this.expenses,
    required this.categoryData,
    required this.aiInsight,
    required this.prediction,
    required this.budgetProgress,
    required this.budget,
    required this.total,
  });

  final List expenses;
  final Map<String, double> categoryData;
  final String aiInsight;
  final String prediction;
  final double budgetProgress;
  final double budget;
  final double total;

  @override
  Widget build(BuildContext context) {
    final categoryEntries = categoryData.entries.toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 10, 28, 28),
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        children: [
          SizedBox(
            width: 520,
            child: _AnalyticsPanel(
              title: 'Category distribution',
              subtitle: 'How spending is split across business categories',
              child: categoryEntries.isEmpty
                  ? _EmptyAnalytics(message: 'Add expenses to render the category pie chart.')
                  : SizedBox(
                      height: 320,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 4,
                          centerSpaceRadius: 72,
                          sections: categoryEntries.map((entry) {
                            final color = categoryColor(entry.key);
                            return PieChartSectionData(
                              color: color,
                              value: entry.value,
                              title: '${entry.value.toStringAsFixed(0)}',
                              radius: 110,
                              titleStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
            ),
          ),
          SizedBox(
            width: 620,
            child: _AnalyticsPanel(
              title: 'Performance insights',
              subtitle: 'Signals that make the tracker feel more useful for customers',
              child: Column(
                children: [
                  _InsightBlock(
                    icon: Icons.auto_graph_rounded,
                    title: 'AI insight',
                    description: aiInsight,
                    color: const Color(0xFF86EFAC),
                  ),
                  const SizedBox(height: 16),
                  _InsightBlock(
                    icon: Icons.trending_up_rounded,
                    title: 'Spend forecast',
                    description: prediction,
                    color: const Color(0xFF4ADE80),
                  ),
                  const SizedBox(height: 16),
                  _InsightBlock(
                    icon: Icons.ssid_chart_rounded,
                    title: 'Budget consumption',
                    description:
                        '${(budgetProgress * 100).toStringAsFixed(0)}% of ${formatCurrency(budget)} consumed with total spend at ${formatCurrency(total)}.',
                    color: const Color(0xFF22C55E),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 1160,
            child: _AnalyticsPanel(
              title: 'Category ranking',
              subtitle: 'Quick breakdown for the categories drawing the most spend',
              child: categoryEntries.isEmpty
                  ? _EmptyAnalytics(message: 'No ranking available yet.')
                  : Column(
                      children: categoryEntries.map((entry) {
                        final share = total == 0 ? 0.0 : entry.value / total;
                        final color = categoryColor(entry.key);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor: color.withOpacity(0.14),
                                    child: Icon(categoryIcon(entry.key), color: color, size: 18),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      entry.key,
                                      style: const TextStyle(fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  Text(
                                    '${(share * 100).toStringAsFixed(1)}%',
                                    style: const TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    formatCurrency(entry.value),
                                    style: TextStyle(color: Colors.grey.shade700),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(999),
                                child: LinearProgressIndicator(
                                  minHeight: 10,
                                  value: share,
                                  backgroundColor: color.withOpacity(0.12),
                                  valueColor: AlwaysStoppedAnimation<Color>(color),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnalyticsPanel extends StatelessWidget {
  const _AnalyticsPanel({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(color: FintechPalette.secondaryTextFor(context))),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}

class _InsightBlock extends StatelessWidget {
  const _InsightBlock({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        border: Border.all(color: color.withOpacity(0.18)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.14),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w700, color: color)),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    height: 1.4,
                    color: FintechPalette.primaryTextFor(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyAnalytics extends StatelessWidget {
  const _EmptyAnalytics({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: Center(
        child: Text(
          message,
          style: TextStyle(color: FintechPalette.secondaryTextFor(context)),
        ),
      ),
    );
  }
}
