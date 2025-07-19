import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:active_gauges/utils/chart_utils.dart';
import 'package:active_gauges/models/ride_models.dart';
import 'package:active_gauges/providers/ride_provider.dart';
import 'package:active_gauges/themes/shared_decorations.dart';
import 'package:active_gauges/widgets/ride_details_chart.dart';

class RideDetailsPage extends ConsumerStatefulWidget {
  const RideDetailsPage({super.key, required this.rideIdx});

  final int rideIdx;

  @override
  ConsumerState<RideDetailsPage> createState() => _RideDetailsPageState();
}

class _RideDetailsPageState extends ConsumerState<RideDetailsPage> {
  SingleRide? ride;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    ride = ref.watch(rideListProvider)[widget.rideIdx];

    return Container(
      decoration: appGradientBackground(isDark: isDark),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(80, 111, 111, 111),
          title: Text(ride!.title),
        ),
        body: ListView(
          children: [
            Text(
              style: TextStyle(fontSize: 30),
              "RIDE DATE: ${DateFormat.yMMMMd().format(ride!.date).toUpperCase()}",
            ),
            RideDetailsChart(rideIdx: widget.rideIdx),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "angle",
                  style: TextStyle(fontSize: 28, color: linePrimaryColor),
                ),
                Text(" - ", style: TextStyle(fontSize: 28)),
                Text(
                  "speed",
                  style: TextStyle(fontSize: 28, color: lineSecondaryColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
