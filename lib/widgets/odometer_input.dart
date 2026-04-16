import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OdometerInput extends StatelessWidget {
  const OdometerInput({
    super.key,
    required this.controller,
    this.label = 'Odometer reading',
  });

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(letterSpacing: 4),
      decoration: InputDecoration(
        labelText: label,
        hintText: '123456',
        prefixIcon: const Icon(Icons.speed),
      ),
    );
  }
}
