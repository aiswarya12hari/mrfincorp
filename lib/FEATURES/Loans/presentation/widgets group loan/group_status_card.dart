import 'package:flutter/material.dart';

enum StatCardType { total, verified, unverified }

class GroupStatsCard extends StatelessWidget {
  final String title;
  final String value;
  final StatCardType type;

  const GroupStatsCard({
    super.key,
    required this.title,
    required this.value,
    required this.type,
  });

  Color get _bg {
    switch (type) {
      case StatCardType.total:
        return const Color(0xFFE3EEFB);
      case StatCardType.verified:
        return const Color(0xFFE3F8EF);
      case StatCardType.unverified:
        return const Color(0xFFFCEDE3);
    }
  }

  Color get _valueColor {
    switch (type) {
      case StatCardType.total:
        return const Color(0xFF2E6FE0);
      case StatCardType.verified:
        return const Color(0xFF1E9E6B);
      case StatCardType.unverified:
        return const Color(0xFFE08A3C);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: _bg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                maxLines: 1,
                style: const TextStyle(fontSize: 11, color: Colors.black54),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _valueColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
