import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../layout/main_layout.dart';
import '../ui/components/animated_counter.dart';
import '../ui/components/animated_reveal.dart';
import '../ui/components/fintech_components.dart';
import '../utils/helpers.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    super.key,
    required this.isLoading,
    required this.total,
    required this.budget,
    required this.remainingBudget,
    required this.budgetProgress,
    required this.summaryCards,
    required this.expenses,
    required this.categoryData,
    required this.aiInsight,
    required this.prediction,
    required this.badge,
    required this.topCategory,
    required this.onOptimizeStrategy,
  });

  final bool isLoading;
  final double total;
  final double budget;
  final double remainingBudget;
  final double budgetProgress;
  final List<SummaryCardData> summaryCards;
  final List expenses;
  final Map<String, double> categoryData;
  final String aiInsight;
  final String prediction;
  final String badge;
  final String topCategory;
  final VoidCallback onOptimizeStrategy;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 1080;
        final heroWidth = isWide ? constraints.maxWidth * 0.56 : constraints.maxWidth;
        final sideWidth = isWide ? constraints.maxWidth - heroWidth - 20 : constraints.maxWidth;
        final statWidth = isWide ? (constraints.maxWidth - 20) / 2 : constraints.maxWidth;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 140),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedReveal(
                child: Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    SizedBox(
                      width: heroWidth,
                      child: _BalanceHero(
                        total: total,
                        remainingBudget: remainingBudget,
                        budgetProgress: budgetProgress,
                        topCategory: topCategory,
                      ),
                    ),
                    SizedBox(
                      width: sideWidth,
                      child: _InsightPanel(
                        aiInsight: aiInsight,
                        prediction: prediction,
                        badge: badge,
                        onOptimizeStrategy: onOptimizeStrategy,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              AnimatedReveal(
                delay: const Duration(milliseconds: 120),
                child: Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    SizedBox(
                      width: statWidth,
                      child: StatCard(
                        title: 'Monthly Budget',
                        value: formatCurrency(budget),
                        icon: Icons.account_balance_wallet_rounded,
                        subtitle: 'Configured spending target for this cycle',
                      ),
                    ),
                    SizedBox(
                      width: statWidth,
                      child: StatCard(
                        title: 'Remaining Funds',
                        value: formatCurrency(remainingBudget < 0 ? 0 : remainingBudget),
                        icon: Icons.savings_rounded,
                        subtitle: 'Available runway before the limit is reached',
                      ),
                    ),
                    for (final card in summaryCards)
                      SizedBox(
                        width: statWidth,
                        child: StatCard(
                          title: card.title,
                          value: card.value,
                          icon: card.icon,
                          subtitle: card.caption,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              AnimatedReveal(
                delay: const Duration(milliseconds: 220),
                child: Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    SizedBox(
                      width: statWidth,
                      child: _ChartShell(
                        title: 'Treasury Growth',
                        subtitle: 'Your recent spend rhythm in a smooth cumulative curve.',
                        child:
                            expenses.isEmpty
                                ? const _EmptyState(message: 'Add expenses to unlock the treasury trend.')
                                : SizedBox(
                                  height: 260,
                                  child: _TrendLineChart(expenses: expenses),
                                ),
                      ),
                    ),
                    SizedBox(
                      width: statWidth,
                      child: _ChartShell(
                        title: 'Allocation',
                        subtitle: 'Green-only category mix inspired by premium wealth dashboards.',
                        child:
                            categoryData.isEmpty
                                ? const _EmptyState(message: 'Add expenses to render allocation.')
                                : SizedBox(
                                  height: 260,
                                  child: _AllocationChart(categoryData: categoryData),
                                ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              AnimatedReveal(
                delay: const Duration(milliseconds: 320),
                child: _ChartShell(
                  title: 'Recent Flow',
                  subtitle: 'Your latest transactions in a cleaner premium ledger view.',
                  child:
                      isLoading
                          ? const SizedBox(
                            height: 180,
                            child: Center(child: CircularProgressIndicator(color: FintechPalette.mint)),
                          )
                          : expenses.isEmpty
                          ? const _EmptyState(message: 'No expenses recorded yet.')
                          : Column(
                            children:
                                expenses.take(5).map((expense) {
                                  final category = expense['category']?.toString() ?? 'Other';
                                  final amount = double.tryParse(expense['amount'].toString()) ?? 0;
                                  final createdAt = DateTime.tryParse(
                                    expense['createdAt']?.toString() ?? '',
                                  );
                                  return _TransactionTile(
                                    category: category,
                                    amount: amount,
                                    createdAt: createdAt,
                                  );
                                }).toList(),
                          ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    required this.selectedPage,
    required this.username,
    required this.isDarkMode,
    required this.onMenuPressed,
    required this.onRefresh,
    required this.onLogout,
    required this.onToggleTheme,
  });

  final AppPage selectedPage;
  final String username;
  final bool isDarkMode;
  final VoidCallback? onMenuPressed;
  final Future<void> Function() onRefresh;
  final Future<void> Function() onLogout;
  final Future<void> Function() onToggleTheme;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.of(context).size.width < 900;
    final initials = username.isEmpty ? 'V' : username.trim()[0].toUpperCase();
    final primaryText = FintechPalette.primaryTextFor(context);
    final secondaryText = FintechPalette.secondaryTextFor(context);
    final popupColor = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF0F4636)
        : const Color(0xFFF7FFF8);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        borderRadius: 28,
        child: Row(
          children: [
            if (onMenuPressed != null) ...[
              _HeaderIconButton(
                icon: Icons.menu_rounded,
                onTap: onMenuPressed!,
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Verdant Wealth',
                    style: TextStyle(
                      color: primaryText,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    compact
                        ? _pageTitle(selectedPage)
                        : '${_pageTitle(selectedPage)} for $username',
                    style: TextStyle(
                      color: secondaryText,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            _HeaderIconButton(
              icon: Icons.notifications_rounded,
              onTap: () {
                onRefresh();
              },
            ),
            const SizedBox(width: 10),
              PopupMenuButton<String>(
                color: popupColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              onSelected: (value) async {
                if (value == 'refresh') {
                  await onRefresh();
                } else if (value == 'theme') {
                  await onToggleTheme();
                } else if (value == 'logout') {
                  await onLogout();
                }
              },
              itemBuilder:
                  (context) => [
                    const PopupMenuItem<String>(value: 'refresh', child: Text('Refresh')),
                    PopupMenuItem<String>(
                      value: 'theme',
                      child: Text(isDarkMode ? 'Switch to Light' : 'Switch to Dark'),
                    ),
                    const PopupMenuItem<String>(value: 'logout', child: Text('Logout')),
                  ],
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(colors: FintechPalette.accentGradient),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x5522C55E),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: const TextStyle(
                      color: FintechPalette.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _pageTitle(AppPage page) {
    switch (page) {
      case AppPage.dashboard:
        return 'Portfolio Home';
      case AppPage.expense:
        return 'Wallet Activity';
      case AppPage.analytics:
        return 'AI Insights';
      case AppPage.reports:
        return 'Wealth Reports';
      case AppPage.settings:
        return 'Workspace Settings';
    }
  }
}

class _BalanceHero extends StatelessWidget {
  const _BalanceHero({
    required this.total,
    required this.remainingBudget,
    required this.budgetProgress,
    required this.topCategory,
  });

  final double total;
  final double remainingBudget;
  final double budgetProgress;
  final String topCategory;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 34,
      padding: const EdgeInsets.all(28),
      gradient: const LinearGradient(
        colors: [
          Color(0xCC0F4636),
          Color(0xCC136B4D),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: Stack(
        children: [
          Positioned(
            right: -18,
            top: 24,
            child: Container(
              width: 110,
              height: 110,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Color(0x6622C55E), Colors.transparent],
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Total Treasury Balance',
                style: TextStyle(
                  color: FintechPalette.textMuted,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              DefaultTextStyle(
                style: const TextStyle(
                  color: FintechPalette.textPrimary,
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
                child: AnimatedCounter(
                  value: total,
                  duration: const Duration(milliseconds: 1100),
                  builder: formatCurrency,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.trending_up_rounded, color: FintechPalette.mintSoft, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Primary pressure point: $topCategory',
                      style: const TextStyle(
                        color: FintechPalette.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  minHeight: 10,
                  value: budgetProgress,
                  backgroundColor: Colors.white.withOpacity(0.08),
                  valueColor: const AlwaysStoppedAnimation<Color>(FintechPalette.mintSoft),
                ),
              ),
              const SizedBox(height: 22),
              LayoutBuilder(
                builder: (context, constraints) {
                  final cardWidth = (constraints.maxWidth - 12) / 2;
                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _HeroMetricCard(
                        width: cardWidth,
                        label: 'Monthly Yield',
                        value: formatCurrency(remainingBudget < 0 ? 0 : remainingBudget),
                      ),
                      _HeroMetricCard(
                        width: cardWidth,
                        label: 'Portfolio Growth',
                        value: '${(budgetProgress * 100).toStringAsFixed(1)}%',
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroMetricCard extends StatelessWidget {
  const _HeroMetricCard({
    required this.width,
    required this.label,
    required this.value,
  });

  final double width;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: FintechPalette.textMuted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: FintechPalette.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightPanel extends StatelessWidget {
  const _InsightPanel({
    required this.aiInsight,
    required this.prediction,
    required this.badge,
    required this.onOptimizeStrategy,
  });

  final String aiInsight;
  final String prediction;
  final String badge;
  final VoidCallback onOptimizeStrategy;

  @override
  Widget build(BuildContext context) {
    final primaryText = FintechPalette.primaryTextFor(context);
    final secondaryText = FintechPalette.secondaryTextFor(context);

    return GlassCard(
      borderRadius: 34,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome_rounded, color: FintechPalette.mintSoft),
              const SizedBox(width: 10),
              Text(
                'AI Wealth Insight',
                style: TextStyle(
                  color: primaryText,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '"$aiInsight"',
            style: TextStyle(
              color: secondaryText,
              height: 1.6,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 18),
          _InsightStrip(
            icon: Icons.trending_up_rounded,
            title: 'Projection',
            value: prediction,
          ),
          const SizedBox(height: 12),
          _InsightStrip(
            icon: Icons.workspace_premium_rounded,
            title: 'Badge',
            value: badge,
          ),
          const SizedBox(height: 22),
          GradientButton(
            label: 'Optimize Strategy',
            icon: Icons.arrow_forward_rounded,
            onPressed: onOptimizeStrategy,
          ),
        ],
      ),
    );
  }
}

class _InsightStrip extends StatelessWidget {
  const _InsightStrip({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final surfaceTint = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : const Color(0xFF0D2B1F);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceTint.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: surfaceTint.withOpacity(0.10)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: surfaceTint.withOpacity(0.07),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: FintechPalette.mintSoft, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: FintechPalette.mutedTextFor(context),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: FintechPalette.primaryTextFor(context),
                    fontWeight: FontWeight.w700,
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

class _ChartShell extends StatelessWidget {
  const _ChartShell({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final primaryText = FintechPalette.primaryTextFor(context);
    final secondaryText = FintechPalette.secondaryTextFor(context);

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: primaryText,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(
              color: secondaryText,
              height: 1.5,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 22),
          child,
        ],
      ),
    );
  }
}

class _TrendLineChart extends StatelessWidget {
  const _TrendLineChart({required this.expenses});

  final List expenses;

  @override
  Widget build(BuildContext context) {
    final points = _buildTrendPoints(expenses);

    return LineChart(
      LineChartData(
        minY: 0,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine:
              (_) => FlLine(
                color: Colors.white.withOpacity(0.08),
                strokeWidth: 1,
              ),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 44,
              interval: points.maxY == 0 ? 1000 : points.maxY / 3,
              getTitlesWidget:
                  (value, meta) => Text(
                    formatCurrency(value),
                    style: const TextStyle(color: FintechPalette.textMuted, fontSize: 10),
                  ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 42,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= points.labels.length) {
                  return const SizedBox.shrink();
                }
                if (!_shouldShowTrendLabel(index, points.labels.length)) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    points.labels[index],
                    style: const TextStyle(
                      color: FintechPalette.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => const Color(0xFF0C3B2D),
            getTooltipItems:
                (spots) =>
                    spots
                        .map(
                          (spot) => LineTooltipItem(
                            formatCurrency(spot.y),
                            const TextStyle(
                              color: FintechPalette.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        )
                        .toList(),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: points.spots,
            isCurved: true,
            barWidth: 4,
            color: FintechPalette.mintSoft,
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  FintechPalette.mint.withOpacity(0.35),
                  FintechPalette.mint.withOpacity(0.02),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            dotData: FlDotData(
              show: true,
              getDotPainter:
                  (spot, percent, barData, index) => FlDotCirclePainter(
                    radius: 4,
                    color: FintechPalette.textPrimary,
                    strokeWidth: 2,
                    strokeColor: FintechPalette.mint,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendData {
  const _TrendData({
    required this.spots,
    required this.labels,
    required this.maxY,
  });

  final List<FlSpot> spots;
  final List<String> labels;
  final double maxY;
}

_TrendData _buildTrendPoints(List expenses) {
  final recent = expenses.take(6).toList().reversed.toList();
  double running = 0;
  final spots = <FlSpot>[];
  final labels = <String>[];

  for (var i = 0; i < recent.length; i++) {
    final item = recent[i];
    final amount = double.tryParse(item['amount'].toString()) ?? 0;
    running += amount;
    spots.add(FlSpot(i.toDouble(), running));

    final date = DateTime.tryParse(item['createdAt']?.toString() ?? '');
    labels.add(
      date == null
          ? 'T${i + 1}'
          : '${_monthShort(date.month)} ${date.day}',
    );
  }

  return _TrendData(
    spots: spots.isEmpty ? const [FlSpot(0, 0)] : spots,
    labels: labels.isEmpty ? const ['Start'] : labels,
    maxY: running <= 0 ? 1000 : running * 1.2,
  );
}

bool _shouldShowTrendLabel(int index, int total) {
  if (total <= 3) return true;
  if (index == 0 || index == total - 1) return true;
  return index == total ~/ 2;
}

String _monthShort(int month) {
  const names = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  return names[month - 1];
}

class _AllocationChart extends StatelessWidget {
  const _AllocationChart({required this.categoryData});

  final Map<String, double> categoryData;

  @override
  Widget build(BuildContext context) {
    final entries = categoryData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final totalValue = entries.fold<double>(0, (sum, entry) => sum + entry.value);

    return Row(
      children: [
        Expanded(
          flex: 5,
          child: PieChart(
            PieChartData(
              centerSpaceRadius: 54,
              sectionsSpace: 4,
              sections: List.generate(entries.length, (index) {
                final entry = entries[index];
                final share = totalValue == 0 ? 0 : entry.value / totalValue;
                return PieChartSectionData(
                  value: entry.value,
                  color: FintechPalette.chartGreens[index % FintechPalette.chartGreens.length],
                  radius: 28,
                  title: '${(share * 100).toStringAsFixed(0)}%',
                  titleStyle: const TextStyle(
                    color: FintechPalette.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                );
              }),
            ),
          ),
        ),
        const SizedBox(width: 18),
        Expanded(
          flex: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(entries.length, (index) {
              final entry = entries[index];
              final share = totalValue == 0 ? 0 : (entry.value / totalValue) * 100;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: FintechPalette.chartGreens[index % FintechPalette.chartGreens.length],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        entry.key,
                        style: const TextStyle(
                          color: FintechPalette.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      '${share.toStringAsFixed(0)}%',
                      style: const TextStyle(
                        color: FintechPalette.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({
    required this.category,
    required this.amount,
    required this.createdAt,
  });

  final String category;
  final double amount;
  final DateTime? createdAt;

  @override
  Widget build(BuildContext context) {
    final subtitle =
        createdAt == null
            ? 'Captured in your ledger'
            : '${_monthShort(createdAt!.month)} ${createdAt!.day}, ${createdAt!.year}';
    final surfaceTint = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : const Color(0xFF0D2B1F);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceTint.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: surfaceTint.withOpacity(0.10)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: surfaceTint.withOpacity(0.07),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              categoryIcon(category),
              color: FintechPalette.mintSoft,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: TextStyle(
                    color: FintechPalette.primaryTextFor(context),
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: FintechPalette.mutedTextFor(context),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '- ${formatCurrency(amount)}',
            style: TextStyle(
              color: FintechPalette.primaryTextFor(context),
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tint = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : const Color(0xFF0D2B1F);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: tint.withOpacity(0.06),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).brightness == Brightness.dark
                ? FintechPalette.mintSoft
                : const Color(0xFF0F8A4A),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: FintechPalette.secondaryTextFor(context),
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
