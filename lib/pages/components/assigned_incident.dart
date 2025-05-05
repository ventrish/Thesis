import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoRow({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.black54),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(width: 5),
            Expanded(
              child: Text(
                value,
                style: TextStyle(color: Colors.black87),
                overflow: TextOverflow.ellipsis, // Para hindi mag overflow
              ),
            ),
          ],
        ),
      );
  }
}
