import 'dart:ui';

import 'package:flutter/material.dart';

class FintechPalette {
  static const Color deepGreen = Color(0xFF062F24);
  static const Color forestGreen = Color(0xFF0A3D2E);
  static const Color emerald = Color(0xFF0F5C45);
  static const Color mint = Color(0xFF22C55E);
  static const Color mintSoft = Color(0xFF86EFAC);
  static const Color surface = Color(0x331A5B45);
  static const Color surfaceLight = Color(0x1FFFFFFF);
  static const Color stroke = Color(0x2EFFFFFF);
  static const Color textPrimary = Color(0xFFF4FFF7);
  static const Color textSecondary = Color(0xFFBFE4D1);
  static const Color textMuted = Color(0xFF89B7A2);

  static const List<Color> pageGradient = [
    Color(0xFF05271D),
    Color(0xFF0A3D2E),
    Color(0xFF0F5C45),
  ];

  static const List<Color> cardGradient = [
    Color(0xAA103D2E),
    Color(0x99217152),
  ];

  static const List<Color> accentGradient = [
    Color(0xFF169B52),
    Color(0xFF22C55E),
    Color(0xFF52D98A),
  ];

  static const List<Color> chartGreens = [
    Color(0xFF22C55E),
    Color(0xFF16A34A),
    Color(0xFF4ADE80),
    Color(0xFF15803D),
    Color(0xFF86EFAC),
  ];

  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static List<Color> pageGradientFor(BuildContext context) {
    if (isDark(context)) {
      return const [
        Color(0xFF041D16),
        Color(0xFF0A3D2E),
        Color(0xFF0E5C43),
      ];
    }

    return const [
      Color(0xFFF7FFF8),
      Color(0xFFE8F7EE),
      Color(0xFFD2F1DD),
    ];
  }

  static List<Color> authGradientFor(BuildContext context) {
    if (isDark(context)) {
      return const [
        Color(0xFF041D16),
        Color(0xFF0B3A2D),
        Color(0xFF12533D),
      ];
    }

    return const [
      Color(0xFFF8FFFA),
      Color(0xFFE4F7EA),
      Color(0xFFCDEFD8),
    ];
  }

  static List<Color> glassGradientFor(BuildContext context) {
    if (isDark(context)) {
      return [
        const Color(0xAA103D2E),
        const Color(0x99217152),
      ];
    }

    return [
      Colors.white.withOpacity(0.86),
      const Color(0xFFE7F8EC).withOpacity(0.88),
    ];
  }

  static List<Color> panelGradientFor(BuildContext context) {
    if (isDark(context)) {
      return [
        surfaceLight,
        surface.withOpacity(0.92),
      ];
    }

    return [
      Colors.white.withOpacity(0.92),
      const Color(0xFFE5F5EA).withOpacity(0.96),
    ];
  }

  static Color strokeFor(BuildContext context) =>
      isDark(context) ? stroke : const Color(0x220E5C43);

  static Color primaryTextFor(BuildContext context) =>
      isDark(context) ? textPrimary : const Color(0xFF0D2B1F);

  static Color secondaryTextFor(BuildContext context) =>
      isDark(context) ? textSecondary : const Color(0xFF335C49);

  static Color mutedTextFor(BuildContext context) =>
      isDark(context) ? textMuted : const Color(0xFF567867);
}

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.borderRadius = 28,
    this.gradient,
    this.onTap,
  });

  final Widget child;
  final EdgeInsets padding;
  final double borderRadius;
  final Gradient? gradient;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final panelGradient = gradient ?? LinearGradient(
      colors: FintechPalette.glassGradientFor(context),
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    final panel = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: padding,
          decoration: BoxDecoration(
            gradient: panelGradient,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: FintechPalette.strokeFor(context)),
            boxShadow: [
              BoxShadow(
                color: FintechPalette.isDark(context)
                    ? const Color(0x33000000)
                    : const Color(0x14072A1F),
                blurRadius: 26,
                offset: Offset(0, 18),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );

    if (onTap == null) {
      return panel;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: panel,
      ),
    );
  }
}

class GradientButton extends StatefulWidget {
  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: widget.onPressed,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 140),
        scale: _pressed ? 0.98 : 1,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: FintechPalette.accentGradient,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(999),
            boxShadow: const [
              BoxShadow(
                color: Color(0x6622C55E),
                blurRadius: 22,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, color: FintechPalette.textPrimary, size: 18),
                const SizedBox(width: 10),
              ],
              Text(
                widget.label,
                style: const TextStyle(
                  color: FintechPalette.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.subtitle,
  });

  final String title;
  final String value;
  final IconData icon;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final primaryText = FintechPalette.primaryTextFor(context);
    final mutedText = FintechPalette.mutedTextFor(context);
    final secondaryText = FintechPalette.secondaryTextFor(context);

    return GlassCard(
      padding: const EdgeInsets.all(18),
      borderRadius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: FintechPalette.mintSoft, size: 20),
          ),
          const SizedBox(height: 16),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              color: mutedText,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: primaryText,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              style: TextStyle(
                color: secondaryText,
                height: 1.4,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class FintechNavItemData {
  const FintechNavItemData({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;
}

class FloatingFintechNav extends StatelessWidget {
  const FloatingFintechNav({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<FintechNavItemData> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 18),
      child: GlassCard(
        borderRadius: 30,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          children: List.generate(items.length, (index) {
            final item = items[index];
            final selected = index == selectedIndex;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: InkWell(
                  borderRadius: BorderRadius.circular(22),
                  onTap: () => onSelected(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      gradient:
                          selected
                              ? const LinearGradient(
                                colors: FintechPalette.accentGradient,
                              )
                              : null,
                      color: selected ? null : Colors.transparent,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          item.icon,
                          color:
                              selected
                                  ? FintechPalette.textPrimary
                                  : FintechPalette.textMuted,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.label,
                          style: TextStyle(
                            color:
                                selected
                                    ? FintechPalette.textPrimary
                                    : FintechPalette.textMuted,
                            fontWeight:
                                selected ? FontWeight.w700 : FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
