import 'package:flutter/material.dart';
import 'dart:convert';

const preLoadedFonts = ["factory font", "font 2", "font 3", "font 4", "font 5"];

const preLoadedBikes = ["factory bike", "bike 2", "bike 3", "bike 4", "bike 5"];

class GaugeSettingsModel {
  Color backgroundNormalColor;
  Color backgroundWarningColor;
  Color arcMainColor;
  Color arcIndicatorColor;
  Color fontColor;
  String currentFont;
  String currentBike;
  double maxiumSafeAngle;

  GaugeSettingsModel({
    required this.backgroundNormalColor,
    required this.backgroundWarningColor,
    required this.arcMainColor,
    required this.arcIndicatorColor,
    required this.fontColor,
    required this.currentFont,
    required this.currentBike,
    required this.maxiumSafeAngle,
  });
}

extension GaugeSettingsSerialization on GaugeSettingsModel {
  Map<String, dynamic> toJson() {
    String colorToHex(Color c) =>
        '#${c.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}';

    return {
      "backgroundNormalColor": colorToHex(backgroundNormalColor),
      "backgroundWarningColor": colorToHex(backgroundWarningColor),
      "arcMainColor": colorToHex(arcMainColor),
      "arcIndicatorColor": colorToHex(arcIndicatorColor),
      "fontColor": colorToHex(fontColor),
      "currentFont": currentFont,
      "currentBike": currentBike,
      "maxiumSafeAngle": maxiumSafeAngle,
    };
  }

  String toBlePayload() => jsonEncode(toJson());
}
