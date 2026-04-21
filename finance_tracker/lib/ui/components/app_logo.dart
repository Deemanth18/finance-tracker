import 'package:flutter/material.dart';

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
    final iconSize = size * 0.42;
    final color = foregroundColor ?? Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size * 0.32),
            gradient: const LinearGradient(
              colors: [Color(0xFF6C63FF), Color(0xFF4F46E5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6C63FF).withOpacity(0.30),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: size * 0.18,
                left: size * 0.18,
                child: Icon(
                  Icons.school_rounded,
                  size: iconSize,
                  color: color.withOpacity(0.95),
                ),
              ),
              Positioned(
                right: size * 0.18,
                bottom: size * 0.18,
                child: Container(
                  width: size * 0.30,
                  height: size * 0.30,
                  decoration: BoxDecoration(
                    color: const Color(0xFFBBF7D0),
                    borderRadius: BorderRadius.circular(size * 0.12),
                  ),
                  child: Icon(
                    Icons.currency_rupee_rounded,
                    size: size * 0.18,
                    color: const Color(0xFF047857),
                  ),
                ),
              ),
            ],
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
