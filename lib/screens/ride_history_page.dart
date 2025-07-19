import 'package:active_gauges/models/ride_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:active_gauges/providers/ride_provider.dart';
import 'package:active_gauges/screens/ride_details_page.dart';
import 'package:active_gauges/themes/shared_decorations.dart';

class RideHistoryPage extends ConsumerStatefulWidget {
  const RideHistoryPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RideHistoryPageState();
}

class _RideHistoryPageState extends ConsumerState<RideHistoryPage> {
  List<SingleRide> rides = [];

  @override
  void initState() {
    super.initState();
    rides = ref.read(rideListProvider);
  }

  void deleteRide(int index) {
    final deletedRide = ref.watch(rideListProvider)[index];
    ref.read(rideListProvider.notifier).deleteRide(index);
    setState(() {
      rides = ref.watch(rideListProvider);
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("ride deleted"),
        action: SnackBarAction(
          label: "undo",
          onPressed: () async {
            ref.read(rideListProvider.notifier).addRide(deletedRide);
            setState(() {
              rides = ref.watch(rideListProvider);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: appGradientBackground(isDark: isDark),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(80, 111, 111, 111),
          title: Text("RIDE LIST"),
        ),
        body: ListView.builder(
          itemCount: rides.length,
          itemBuilder: (ctx, idx) => Dismissible(
            key: Key(rides[idx].id),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            confirmDismiss: (_) async {
              return await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text(
                    style: TextStyle(fontSize: 22),
                    "DELETE RIDE?",
                  ),
                  content: const Text(
                    style: TextStyle(fontSize: 20),
                    "are you sure you want to delete this ride?",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text(
                        style: TextStyle(fontSize: 18),
                        "cancel",
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text(
                        style: TextStyle(fontSize: 18),
                        "delete",
                      ),
                    ),
                  ],
                ),
              );
            },
            onDismissed: (_) => deleteRide(idx),
            child: ListTile(
              title: Text(
                DateFormat.yMMMMd().format(rides[idx].date).toLowerCase(),
              ),
              subtitle: Text(rides[idx].title),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => RideDetailsPage(rideIdx: idx),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
