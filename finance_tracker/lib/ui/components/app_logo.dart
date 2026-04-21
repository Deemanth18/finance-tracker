import 'package:flutter/material.dart';

import 'fintech_components.dart';

class StudentFinanceLogo extends StatelessWidget {
  const StudentFinanceLogo({
    super.key,
    this.size = 56,
    this.showLabel = true,
    this.title = 'Student Finance',
    this.subtitle = 'Smart tracker',
    this.foregroundColor,
  });

  final double size;
  final bool showLabel;
  final String title;
  final String subtitle;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final color =
        foregroundColor ??
        Theme.of(context).textTheme.bodyLarge?.color ??
        FintechPalette.primaryTextFor(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size * 0.24),
            boxShadow: [
              BoxShadow(
                color: const Color(0x220B3A2D),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            'assets/logo.png',
            fit: BoxFit.cover,
          ),
        ),
        if (showLabel) ...[
          const SizedBox(width: 14),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color.withOpacity(0.78),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
