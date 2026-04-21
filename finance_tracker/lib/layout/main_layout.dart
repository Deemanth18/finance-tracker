import 'package:flutter/material.dart';

import '../screens/analytics_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/expense_screen.dart';
import '../screens/reports_screen.dart';
import '../screens/settings_screen.dart';
import '../services/api_service.dart';
import '../ui/components/fintech_components.dart';
import '../utils/ai_insights.dart';
import '../utils/filter.dart';
import '../utils/gamification.dart';
import '../utils/helpers.dart';
import '../utils/pdf_export.dart';
import '../widgets/sidebar.dart';

enum AppPage { dashboard, expense, analytics, reports, settings }

class MainLayout extends StatefulWidget {
  const MainLayout({
    super.key,
    required this.username,
    required this.onLogout,
    required this.themeMode,
    required this.onToggleTheme,
  });

  final String username;
  final Future<void> Function() onLogout;
  final ThemeMode themeMode;
  final Future<void> Function() onToggleTheme;

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  List expenses = [];
  AppPage selectedPage = AppPage.dashboard;
  String selectedCategory = 'Food';
  String filterCategory = 'All';
  double budget = 5000;
  bool notificationsEnabled = true;
  bool weeklySummary = true;
  bool isLoading = true;
  bool isSidebarCollapsed = false;

  @override
  void initState() {
    super.initState();
    fetchExpenses();
  }

  @override
  void dispose() {
    amountController.dispose();
    budgetController.dispose();
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchExpenses() async {
    setState(() => isLoading = true);
    final data = await ApiService.fetchExpenses();
    if (!mounted) return;

    setState(() {
      expenses = data;
      isLoading = false;
    });
    _checkBudgetAlert();
  }

  Future<void> addExpense() async {
    if (amountController.text.trim().isEmpty) return;

    await ApiService.addExpense(amountController.text.trim(), selectedCategory);
    amountController.clear();
    if (!mounted) return;

    Navigator.of(context).maybePop();
    await fetchExpenses();
    if (!mounted) return;
    setState(() => selectedPage = AppPage.expense);
  }

  Future<void> deleteExpense(String id) async {
    await ApiService.deleteExpense(id);
    await fetchExpenses();
  }

  void updateBudget() {
    setState(() {
      budget = double.tryParse(budgetController.text.trim()) ?? budget;
    });
    Navigator.of(context).maybePop();
    _checkBudgetAlert();
  }

  void _checkBudgetAlert() {
    if (!mounted || getTotal(expenses) <= budget) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.deepOrange),
              SizedBox(width: 10),
              Text('Budget alert'),
            ],
          ),
          content: const Text(
            'Your current spending has exceeded the monthly budget target.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    });
  }

  void showAddExpenseSheet() {
    selectedCategory = 'Food';
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ExpenseFormSheet(
        amountController: amountController,
        selectedCategory: selectedCategory,
        onCategoryChanged: (value) {
          setState(() => selectedCategory = value);
        },
        onSubmit: addExpense,
      ),
    );
  }

  void showBudgetSheet() {
    budgetController.text = budget.toStringAsFixed(0);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BudgetSettingsSheet(
        budgetController: budgetController,
        onSubmit: updateBudget,
      ),
    );
  }

  void onNavSelected(AppPage page) {
    setState(() => selectedPage = page);
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final total = getTotal(expenses);
    final categoryData = getCategoryData(expenses);
    final filteredExpenses = filterExpenses(
      expenses,
      searchController.text,
      filterCategory,
    );
    final topCategory = getTopCategory(categoryData);
    final remainingBudget = budget - total;
    final budgetProgress = budget <= 0 ? 0.0 : (total / budget).clamp(0.0, 1.0);
    final summaryCards = buildSummaryCards(total, budget, categoryData);
    final isDesktop = MediaQuery.of(context).size.width >= 1000;
    final mobileNavPages = <AppPage>[
      AppPage.dashboard,
      AppPage.analytics,
      AppPage.expense,
      AppPage.settings,
    ];
    final mobileNavIndex = mobileNavPages.contains(selectedPage)
        ? mobileNavPages.indexOf(selectedPage)
        : 0;

    return Scaffold(
      extendBody: true,
      drawer: isDesktop
          ? null
          : Drawer(
              backgroundColor: const Color(0xFF073728),
              child: Sidebar(
                isCollapsed: false,
                selectedPage: selectedPage,
                onItemSelected: onNavSelected,
                onToggleCollapse: () {},
              ),
            ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: FintechPalette.pageGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Builder(
            builder: (scaffoldContext) {
              return Stack(
                children: [
                  Positioned(
                    top: -120,
                    right: -90,
                    child: Container(
                      width: 280,
                      height: 280,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [Color(0x4422C55E), Colors.transparent],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: -110,
                    bottom: 30,
                    child: Container(
                      width: 260,
                      height: 260,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [Color(0x2216A34A), Colors.transparent],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      if (isDesktop)
                        Sidebar(
                          isCollapsed: isSidebarCollapsed,
                          selectedPage: selectedPage,
                          onItemSelected: onNavSelected,
                          onToggleCollapse: () {
                            setState(() => isSidebarCollapsed = !isSidebarCollapsed);
                          },
                        ),
                      Expanded(
                        child: Column(
                          children: [
                            DashboardHeader(
                              selectedPage: selectedPage,
                              username: widget.username,
                              isDarkMode: widget.themeMode == ThemeMode.dark,
                              onMenuPressed: isDesktop
                                  ? null
                                  : () => Scaffold.of(scaffoldContext).openDrawer(),
                              onRefresh: fetchExpenses,
                              onLogout: widget.onLogout,
                              onToggleTheme: widget.onToggleTheme,
                            ),
                            Expanded(
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 350),
                                switchInCurve: Curves.easeOutCubic,
                                switchOutCurve: Curves.easeInCubic,
                                child: KeyedSubtree(
                                  key: ValueKey(selectedPage),
                                  child: _buildPage(
                                    total: total,
                                    categoryData: categoryData,
                                    filteredExpenses: filteredExpenses,
                                    topCategory: topCategory,
                                    remainingBudget: remainingBudget,
                                    budgetProgress: budgetProgress,
                                    summaryCards: summaryCards,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: selectedPage == AppPage.expense || isDesktop
          ? FloatingActionButton.extended(
              onPressed: showAddExpenseSheet,
              backgroundColor: FintechPalette.mint,
              foregroundColor: FintechPalette.textPrimary,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add expense'),
            )
          : null,
      bottomNavigationBar: isDesktop
          ? null
          : FloatingFintechNav(
              items: const [
                FintechNavItemData(icon: Icons.home_rounded, label: 'Home'),
                FintechNavItemData(icon: Icons.auto_graph_rounded, label: 'Insights'),
                FintechNavItemData(icon: Icons.account_balance_wallet_rounded, label: 'Wallet'),
                FintechNavItemData(icon: Icons.settings_rounded, label: 'Settings'),
              ],
              selectedIndex: mobileNavIndex,
              onSelected: (index) => onNavSelected(mobileNavPages[index]),
            ),
    );
  }

  Widget _buildPage({
    required double total,
    required Map<String, double> categoryData,
    required List filteredExpenses,
    required String topCategory,
    required double remainingBudget,
    required double budgetProgress,
    required List<SummaryCardData> summaryCards,
  }) {
    switch (selectedPage) {
      case AppPage.dashboard:
        return DashboardScreen(
          isLoading: isLoading,
          total: total,
          budget: budget,
          remainingBudget: remainingBudget,
          budgetProgress: budgetProgress,
          summaryCards: summaryCards,
          expenses: expenses,
          categoryData: categoryData,
          aiInsight: getAIInsight(expenses, budget),
          prediction: getPrediction(expenses),
          badge: getBadge(total),
          topCategory: topCategory,
          onAddExpense: showAddExpenseSheet,
        );
      case AppPage.expense:
        return ExpenseScreen(
          expenses: filteredExpenses,
          searchController: searchController,
          filterCategory: filterCategory,
          onFilterChanged: (value) => setState(() => filterCategory = value),
          onSearchChanged: (_) => setState(() {}),
          onAddExpense: showAddExpenseSheet,
          onDeleteExpense: deleteExpense,
          total: total,
          topCategory: topCategory,
        );
      case AppPage.analytics:
        return AnalyticsScreen(
          expenses: expenses,
          categoryData: categoryData,
          aiInsight: getAIInsight(expenses, budget),
          prediction: getPrediction(expenses),
          budgetProgress: budgetProgress,
          budget: budget,
          total: total,
        );
      case AppPage.reports:
        return ReportsScreen(
          expenses: expenses,
          total: total,
          budget: budget,
          topCategory: topCategory,
          onExportPdf: () => generatePDF(expenses),
        );
      case AppPage.settings:
        return SettingsScreen(
          budget: budget,
          notificationsEnabled: notificationsEnabled,
          weeklySummary: weeklySummary,
          username: widget.username,
          onSetBudget: showBudgetSheet,
          onLogout: widget.onLogout,
          onNotificationsChanged: (value) {
            setState(() => notificationsEnabled = value);
          },
          onWeeklySummaryChanged: (value) {
            setState(() => weeklySummary = value);
          },
        );
    }
  }
}
