import 'package:flutter/material.dart';

import '../utils/helpers.dart';
import 'expense_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.budget,
    required this.notificationsEnabled,
    required this.weeklySummary,
    required this.username,
    required this.onSetBudget,
    required this.onLogout,
    required this.onNotificationsChanged,
    required this.onWeeklySummaryChanged,
  });

  final double budget;
  final bool notificationsEnabled;
  final bool weeklySummary;
  final String username;
  final VoidCallback onSetBudget;
  final Future<void> Function() onLogout;
  final ValueChanged<bool> onNotificationsChanged;
  final ValueChanged<bool> onWeeklySummaryChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 10, 28, 28),
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        children: [
          _SettingsPanel(
            title: 'Budget controls',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.06)
                        : const Color(0xFFF5F3FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.account_balance_wallet_rounded, color: Colors.deepPurple),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Current monthly budget',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              formatCurrency(budget),
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 22,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: onSetBudget,
                        child: const Text('Update'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _SettingsPanel(
            title: 'Preferences',
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFEDE9FE),
                    child: Icon(Icons.person_rounded, color: Colors.deepPurple),
                  ),
                  title: Text(username),
                  subtitle: const Text('Authenticated workspace user'),
                  trailing: TextButton.icon(
                    onPressed: onLogout,
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text('Logout'),
                  ),
                ),
                const Divider(),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Budget notifications'),
                  subtitle: const Text('Show alerts when spending crosses the budget threshold.'),
                  value: notificationsEnabled,
                  onChanged: onNotificationsChanged,
                ),
                const Divider(),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Weekly summary'),
                  subtitle: const Text('Keep quick performance summaries enabled in the workspace.'),
                  value: weeklySummary,
                  onChanged: onWeeklySummaryChanged,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsPanel extends StatelessWidget {
  const _SettingsPanel({
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
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}
