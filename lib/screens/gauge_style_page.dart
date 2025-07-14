import 'package:active_gauges/providers/gps_provider.dart';
import 'package:active_gauges/widgets/gauge_settings/custom_dropdown_menu.dart';
import 'package:active_gauges/widgets/gauge_settings/gauge_color_picker_list.dart';
import 'package:active_gauges/widgets/gauge_settings/number_input.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:active_gauges/providers/ble_provider.dart';

import 'package:active_gauges/themes/shared_decorations.dart';
import 'package:active_gauges/models/gauge_setting_model.dart';

// ignore: must_be_immutable
class GaugeStylePage extends ConsumerStatefulWidget {
  GaugeStylePage({super.key});

  GaugeSettingsModel settings = GaugeSettingsModel(
    backgroundNormalColor: const Color.fromARGB(255, 37, 37, 37),
    backgroundWarningColor: const Color.fromARGB(200, 128, 0, 0),
    arcMainColor: const Color.fromARGB(209, 0, 70, 9),
    arcIndicatorColor: const Color.fromARGB(115, 255, 255, 255),
    fontColor: const Color.fromARGB(255, 255, 254, 254),
    currentFont: preLoadedFonts[0],
    currentBike: preLoadedBikes[0],
    maxiumSafeAngle: 29,
  );

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _GaugeStylePageState();
  }
}

class _GaugeStylePageState extends ConsumerState<GaugeStylePage> {
  @override
  void initState() {
    super.initState();
    final ble = ref.read(bleProvider);
    if (ble.connectedDevice == null || !ble.isConnected) {
      ref.read(bleProvider.notifier).startScanAndConnect();
    }
    ref.read(gpsProvider.notifier).startTracking();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isConnected = ref.watch(bleProvider).isConnected;

    return Container(
      decoration: appGradientBackground(isDark: isDark),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(80, 111, 111, 111),
          title: Text("GAUGE SETTINGS"),
        ),
        body: Center(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 70),
            children: [
              const SizedBox(height: 40),
              GaugeColorPickerList(
                settings: widget.settings,
                onSettingsChanged: (newSettings) {
                  setState(() => widget.settings = newSettings);
                },
              ),
              CustomDropdownMenu(
                workingList: preLoadedFonts,
                updateContent: (font) =>
                    setState(() => widget.settings.currentFont = font),
                currentItem: widget.settings.currentFont,
              ),
              const SizedBox(height: 10),
              CustomDropdownMenu(
                workingList: preLoadedBikes,
                updateContent: (bike) =>
                    setState(() => widget.settings.currentBike = bike),
                currentItem: widget.settings.currentBike,
              ),
              const SizedBox(height: 10),
              NumberInput(
                settings: widget.settings,
                onTap: (value) => setState(() {
                  widget.settings.maxiumSafeAngle =
                      double.tryParse(value) ?? widget.settings.maxiumSafeAngle;
                }),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                onPressed: () async {
                  if (!isConnected) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('device not connected')),
                    );
                    return;
                  }
                  final bleController = ref.read(bleProvider.notifier);
                  await bleController.sendGaugeSettings(widget.settings);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('settings sent to gauge')),
                  );
                },
                label: const Text("save changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
