import 'package:flutter/material.dart';

class IconText extends StatelessWidget {
  const IconText(
      {Key? key,
      required this.icon,
      required this.label,
      this.color = Colors.white,
      this.size = 12,
      this.iconSize = 15})
      : super(key: key);

  final IconData icon;
  final String label;
  final double iconSize;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: color,
          size: iconSize,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: size,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
