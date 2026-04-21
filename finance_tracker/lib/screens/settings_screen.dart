import 'package:flutter/material.dart';

import '../ui/components/fintech_components.dart';
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
    final primaryText = FintechPalette.primaryTextFor(context);
    final secondaryText = FintechPalette.secondaryTextFor(context);

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
                    color: const Color(0x1A86EFAC),
                    border: Border.all(color: FintechPalette.strokeFor(context)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Color(0x2286EFAC),
                        child: Icon(Icons.account_balance_wallet_rounded, color: Color(0xFF86EFAC)),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Current monthly budget',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: secondaryText,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              formatCurrency(budget),
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 22,
                                color: primaryText,
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
                    backgroundColor: Color(0x2286EFAC),
                    child: Icon(Icons.person_rounded, color: Color(0xFF86EFAC)),
                  ),
                  title: Text(
                    username,
                    style: TextStyle(color: primaryText),
                  ),
                  subtitle: Text(
                    'Authenticated workspace user',
                    style: TextStyle(color: secondaryText),
                  ),
                  trailing: TextButton.icon(
                    onPressed: onLogout,
                    icon: const Icon(Icons.logout_rounded, color: Color(0xFF4ADE80)),
                    label: const Text('Logout', style: TextStyle(color: Color(0xFF4ADE80))),
                  ),
                ),
                Divider(color: FintechPalette.strokeFor(context)),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  activeColor: const Color(0xFF22C55E),
                  title: Text(
                    'Budget notifications',
                    style: TextStyle(color: primaryText),
                  ),
                  subtitle: Text(
                    'Show alerts when spending crosses the budget threshold.',
                    style: TextStyle(color: secondaryText),
                  ),
                  value: notificationsEnabled,
                  onChanged: onNotificationsChanged,
                ),
                Divider(color: FintechPalette.strokeFor(context)),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  activeColor: const Color(0xFF22C55E),
                  title: Text(
                    'Weekly summary',
                    style: TextStyle(color: primaryText),
                  ),
                  subtitle: Text(
                    'Keep quick performance summaries enabled in the workspace.',
                    style: TextStyle(color: secondaryText),
                  ),
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
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 20,
              color: FintechPalette.primaryTextFor(context),
            ),
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}
