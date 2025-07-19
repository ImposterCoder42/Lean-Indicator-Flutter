import 'package:active_gauges/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:active_gauges/providers/ble_provider.dart';
import 'package:active_gauges/themes/shared_decorations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GaugeResetPage extends ConsumerWidget {
  const GaugeResetPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: appGradientBackground(isDark: isDark),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(80, 111, 111, 111),
          title: Text("RESET OPTIONS"),
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  final success = await ref
                      .read(bleProvider.notifier)
                      .prReset();

                  await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(success ? 'success' : 'uh-oh'),
                        content: Text(
                          style: TextStyle(fontSize: 20),
                          success
                              ? 'personal record reset successfully.'
                              : 'failed to personal record reset.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                  if (success) {
                    Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (_) => HomePage()));
                  }
                },
                child: const Text('person record reset'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final success = await ref
                      .read(bleProvider.notifier)
                      .factoryReset();

                  await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(success ? 'success' : 'uh-oh'),
                        content: Text(
                          style: TextStyle(fontSize: 20),
                          success
                              ? 'factory reset was successfully.'
                              : 'failed to perform factory reset.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                  if (success) {
                    Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (_) => HomePage()));
                  }
                },
                child: const Text('factory reset'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
