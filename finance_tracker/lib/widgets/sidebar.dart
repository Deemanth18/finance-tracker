import 'package:flutter/material.dart';

import '../layout/main_layout.dart';
import '../ui/components/app_logo.dart';
import '../ui/components/glass_panel.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({
    super.key,
    required this.selectedPage,
    required this.onItemSelected,
    required this.isCollapsed,
    required this.onToggleCollapse,
  });

  final AppPage selectedPage;
  final ValueChanged<AppPage> onItemSelected;
  final bool isCollapsed;
  final VoidCallback onToggleCollapse;

  static const double expandedWidth = 280;
  static const double collapsedWidth = 94;

  @override
  Widget build(BuildContext context) {
    const items = <_SidebarItemData>[
      _SidebarItemData(AppPage.dashboard, 'Dashboard', Icons.space_dashboard_rounded),
      _SidebarItemData(AppPage.expense, 'Add Expense', Icons.receipt_long_rounded),
      _SidebarItemData(AppPage.analytics, 'Analytics', Icons.pie_chart_rounded),
      _SidebarItemData(AppPage.reports, 'Reports', Icons.picture_as_pdf_rounded),
      _SidebarItemData(AppPage.settings, 'Settings', Icons.settings_rounded),
    ];

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      width: isCollapsed ? collapsedWidth : expandedWidth,
      padding: const EdgeInsets.fromLTRB(14, 24, 14, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlassPanel(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Center(
              child: IconButton(
                onPressed: onToggleCollapse,
                icon: Icon(
                  isCollapsed
                      ? Icons.keyboard_double_arrow_right_rounded
                      : Icons.keyboard_double_arrow_left_rounded,
                  color: isDark ? Colors.white : const Color(0xFF4338CA),
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          for (final item in items)
            _SidebarTile(
              data: item,
              isCollapsed: isCollapsed,
              isSelected: selectedPage == item.page,
              onTap: () => onItemSelected(item.page),
            ),
          const Spacer(),
          if (!isCollapsed)
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 180) return const SizedBox.shrink();
                return GlassPanel(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cashflow health',
                        style: TextStyle(
                          color: isDark ? Colors.white : const Color(0xFF1E1B4B),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Track allowances, course spending, travel, and study-life costs in one calm workspace.',
                        style: TextStyle(
                          color: isDark ? Colors.white70 : const Color(0xFF6B7280),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                );
              }
            ),
        ],
      ),
    );
  }
}

class _SidebarTile extends StatefulWidget {
  const _SidebarTile({
    required this.data,
    required this.isCollapsed,
    required this.isSelected,
    required this.onTap,
  });

  final _SidebarItemData data;
  final bool isCollapsed;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_SidebarTile> createState() => _SidebarTileState();
}

class _SidebarTileState extends State<_SidebarTile> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.isSelected || isHovering;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: MouseRegion(
        onEnter: (_) => setState(() => isHovering = true),
        onExit: (_) => setState(() => isHovering = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          decoration: BoxDecoration(
            color: active
                ? const Color(0xFF6C63FF).withOpacity(widget.isSelected ? 0.28 : 0.16)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: widget.isSelected
                  ? const Color(0xFF8B85FF).withOpacity(0.40)
                  : Colors.transparent,
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: widget.onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.isCollapsed ? 0 : 18,
                vertical: 10,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Row(
                    mainAxisAlignment: widget.isCollapsed
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.start,
                    children: [
                      Icon(widget.data.icon, color: active ? const Color(0xFF6C63FF) : null),
                      if (!widget.isCollapsed && constraints.maxWidth > 40) ...[
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            widget.data.label,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: TextStyle(
                              color: active ? const Color(0xFF6C63FF) : null,
                              fontWeight: widget.isSelected ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                }
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SidebarItemData {
  const _SidebarItemData(this.page, this.label, this.icon);

  final AppPage page;
  final String label;
  final IconData icon;
}
