import 'package:flutter/material.dart';

import 'package:active_gauges/models/gauge_setting_model.dart';
import 'package:active_gauges/widgets/gauge_settings/custom_color_picker.dart';

class GaugeColorPickerList extends StatelessWidget {
  const GaugeColorPickerList({
    super.key,
    required this.settings,
    required this.onSettingsChanged,
  });

  final GaugeSettingsModel settings;
  final ValueChanged<GaugeSettingsModel> onSettingsChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildColorPicker(
          title: "choose a new background color",
          tooltip: "this is the main background color",
          label: "background color",
          color: settings.backgroundNormalColor,
          onColorChanged: (color) {
            onSettingsChanged(settings..backgroundNormalColor = color);
          },
        ),
        _buildColorPicker(
          title: "choose a new background warning color",
          tooltip:
              "this is the color the background will flash to when you exceed the maximum safe lean angle",
          label: "warning color",
          color: settings.backgroundWarningColor,
          onColorChanged: (color) {
            onSettingsChanged(settings..backgroundWarningColor = color);
          },
        ),
        _buildColorPicker(
          title: "choose a new main arc color",
          tooltip: "this is the main arc color of the arch bar",
          label: "arc main color",
          color: settings.arcMainColor,
          onColorChanged: (color) {
            onSettingsChanged(settings..arcMainColor = color);
          },
        ),
        _buildColorPicker(
          title: "choose a new arc indicator color",
          tooltip: "this is the filled section of the arch bar",
          label: "arc indicator color",
          color: settings.arcIndicatorColor,
          onColorChanged: (color) {
            onSettingsChanged(settings..arcIndicatorColor = color);
          },
        ),
        _buildColorPicker(
          title: "choose a new font color",
          tooltip: "this is the gauge font color",
          label: "font color",
          color: settings.fontColor,
          onColorChanged: (color) {
            onSettingsChanged(settings..fontColor = color);
          },
        ),
      ],
    );
  }

  Widget _buildColorPicker({
    required String title,
    required String tooltip,
    required String label,
    required Color color,
    required ValueChanged<Color> onColorChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: CustomColorPicker(
        workingColor: color,
        title: title,
        tooltipMessage: tooltip,
        buttonLable: label,
        updateColor: onColorChanged,
      ),
    );
  }
}
