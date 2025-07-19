import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:active_gauges/models/gauge_setting_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/data_processors.dart';

final bleProvider = StateNotifierProvider<BleController, BleState>(
  (ref) => BleController(),
);

class BleState {
  final BluetoothDevice? connectedDevice;
  final bool isConnected;
  final double? leanAngle;

  BleState({this.connectedDevice, this.isConnected = false, this.leanAngle});

  BleState copyWith({
    BluetoothDevice? connectedDevice,
    bool? isConnected,
    double? leanAngle,
  }) {
    return BleState(
      connectedDevice: connectedDevice ?? this.connectedDevice,
      isConnected: isConnected ?? this.isConnected,
      leanAngle: leanAngle ?? this.leanAngle,
    );
  }
}

class BleController extends StateNotifier<BleState> {
  BleController() : super(BleState()) {
    _leanProcessor = LeanAngleProcessor();
  }

  final serviceUuidLeanAngle = Guid("4fafc201-1fb5-459e-8fcc-c5c9c331914b");
  final charUuidLeanAngle = Guid("beb5483e-36e1-4688-b7f5-ea07361b26a8");

  final serviceUuidSettings = Guid("9703c1da-f099-4fb7-b7e3-6ac16aae762a");
  final charUuidSettings = Guid("c8bfda4a-3a28-4ba0-8df5-cbf1a7214cb9");

  StreamSubscription<List<int>>? _bleDataSub;
  StreamSubscription<BluetoothConnectionState>? _deviceStateSub;

  late LeanAngleProcessor _leanProcessor;

  Future<void> startScanAndConnect() async {
    FlutterBluePlus.scanResults.listen((results) async {
      for (ScanResult result in results) {
        if (result.advertisementData.advName == "Active-Gauges") {
          await FlutterBluePlus.stopScan();
          try {
            await result.device.connect();
            _deviceStateSub = result.device.connectionState.listen((state) {
              if (!mounted) return;
              state = state;
            });
            if (!mounted) return;
            state = state.copyWith(
              connectedDevice: result.device,
              isConnected: true,
            );

            await _discoverServices(result.device);
          } catch (e) {
            print("BLE connect error: $e");
          }
          break;
        }
      }
    });

    FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
  }

  Future<void> _discoverServices(BluetoothDevice device) async {
    List<BluetoothService> services = await device.discoverServices();
    for (BluetoothService service in services) {
      if (service.uuid == serviceUuidLeanAngle) {
        for (BluetoothCharacteristic c in service.characteristics) {
          if (c.uuid == charUuidLeanAngle) {
            await c.setNotifyValue(true);
            _bleDataSub = c.onValueReceived.listen(_onDataReceived);
          }
        }
      }
    }
  }

  void _onDataReceived(List<int> value) {
    if (value.length >= 2) {
      final byteData = ByteData.sublistView(Uint8List.fromList(value));
      final angle = byteData.getInt16(0, Endian.little);
      print(angle);
      final cleanAngle = _leanProcessor.process(angle.toDouble());
      if (!mounted) return;
      state = state.copyWith(leanAngle: cleanAngle);
    }
  }

  Future<void> sendGaugeSettings(GaugeSettingsModel settings) async {
    if (state.connectedDevice == null) {
      print("Device not connected");
      return;
    }

    List<BluetoothService> services = await state.connectedDevice!
        .discoverServices();

    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.uuid == charUuidSettings) {
          final payload = utf8.encode(settings.toBlePayload());

          try {
            await characteristic.write(payload, withoutResponse: false);
            print("Settings sent successfully.");
          } catch (e) {
            print("Failed to send settings: $e");
          }

          return;
        }
      }
    }

    print("Settings characteristic not found.");
  }

  Future<bool> prReset() async {
    if (state.connectedDevice == null) {
      print("Device not connected");
      return false;
    }

    List<BluetoothService> services = await state.connectedDevice!
        .discoverServices();

    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.uuid == charUuidSettings) {
          final payload = utf8.encode("PR_RESET");
          try {
            await characteristic.write(payload, withoutResponse: false);
            print("Settings sent successfully.");
            return true;
          } catch (e) {
            print("Failed to send settings: $e");
            return false;
          }
        }
      }
    }
    print("Settings characteristic not found.");
    return false;
  }

  Future<bool> factoryReset() async {
    if (state.connectedDevice == null) {
      print("Device not connected");
      return false;
    }

    List<BluetoothService> services = await state.connectedDevice!
        .discoverServices();

    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.uuid == charUuidSettings) {
          final payload = utf8.encode("FACTORY_RESET");
          try {
            await characteristic.write(payload, withoutResponse: false);
            print("Settings sent successfully.");
            return true;
          } catch (e) {
            print("Failed to send settings: $e");
            return false;
          }
        }
      }
    }
    print("Settings characteristic not found.");
    return false;
  }

  Future<void> disconnect() async {
    if (state.connectedDevice != null) {
      await state.connectedDevice!.disconnect();
    }
    _bleDataSub?.cancel();
    _deviceStateSub?.cancel();
    state = BleState(); // reset state
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }

  void tryReconnectToSavedDevice() async {
    final id = await getLastConnectedDeviceId();
    if (id != null) {
      final device = BluetoothDevice(remoteId: DeviceIdentifier(id));
      print("Attempting auto-reconnect to $id");

      for (int i = 0; i < 5; i++) {
        try {
          await device.connect(autoConnect: true);
          state = state.copyWith(connectedDevice: device);
          print("Reconnected to $id");
          return;
        } catch (e) {
          print("Reconnect attempt ${i + 1} failed: $e");
          await Future.delayed(Duration(seconds: 2));
        }
      }
      print("Failed to reconnect to $id after 5 attempts");
    } else {
      startScanAndConnect();
    }
  }

  Future<void> saveLastConnectedDeviceId(String deviceId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastDeviceId', deviceId);
  }

  Future<String?> getLastConnectedDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('lastDeviceId');
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect(autoConnect: true);
      state = state.copyWith(connectedDevice: device);
      await saveLastConnectedDeviceId(device.remoteId.id);

      // Optional: listen to connection changes
      device.state.listen((status) {
        if (status == BluetoothConnectionState.disconnected) {
          _handleDisconnect(device);
        }
      });

      print("Connected to device: ${device.advName}");
    } catch (e) {
      print("Connection failed: $e");
    }
  }

  void _handleDisconnect(BluetoothDevice device) {
    print("Disconnected from ${device.remoteId.id}, attempting reconnect...");

    for (int i = 0; i < 3; i++) {
      Future.delayed(Duration(seconds: 2 * i), () async {
        try {
          await device.connect(autoConnect: true);
          state = state.copyWith(connectedDevice: device);
          print("Reconnected after disconnect");
        } catch (e) {
          print("Reconnect failed: $e");
        }
      });
    }
  }
}
