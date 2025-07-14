import 'package:active_gauges/widgets/gauge_settings/tooltip_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class CustomColorPicker extends StatelessWidget {
  const CustomColorPicker({
    super.key,
    required this.workingColor,
    required this.title,
    required this.tooltipMessage,
    required this.buttonLable,
    required this.updateColor,
  });

  final Color workingColor;
  final String title;
  final String tooltipMessage;
  final String buttonLable;
  final void Function(Color newcolor) updateColor;

  @override
  Widget build(BuildContext context) {
    void showColoPicker(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ColorPicker(
                    pickerColor: workingColor,
                    onColorChanged: updateColor,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("select"),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return TooltipButton(
      tooltipMessage: tooltipMessage,
      buttonLable: buttonLable,
      onTap: () => showColoPicker(context),
    );
  }
}
