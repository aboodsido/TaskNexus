import 'package:flutter/material.dart';

class ContactDetail extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ContactDetail({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: TextStyle(fontSize: 16, color: Colors.indigo.shade800),
        ),
      ],
    );
  }
}
