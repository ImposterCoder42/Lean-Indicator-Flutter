import 'package:active_gauges/models/gauge_setting_model.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

class NumberInput extends StatelessWidget {
  const NumberInput({super.key, required this.settings, required this.onTap});

  final GaugeSettingsModel settings;
  final Function(String value) onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: TextField(
        decoration: const InputDecoration(labelText: "set maximum safe angle"),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) {
          onTap(value);
        },
      ),
    );
  }
}
