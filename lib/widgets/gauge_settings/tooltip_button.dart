import 'package:flutter/material.dart';

class TooltipButton extends StatelessWidget {
  const TooltipButton({
    super.key,
    required this.tooltipMessage,
    required this.buttonLable,
    required this.onTap,
  });

  final String tooltipMessage;
  final String buttonLable;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltipMessage,
      child: ElevatedButton(onPressed: onTap, child: Text(buttonLable)),
    );
  }
}
