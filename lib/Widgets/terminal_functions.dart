import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:kiosk_app/GPTCodeForTerminal/terminal/models/discovery_method.dart';
import 'package:kiosk_app/GPTCodeForTerminal/terminal/models/k.dart';
import 'package:kiosk_app/GPTCodeForTerminal/terminal/stripe_api.dart';
import 'package:kiosk_app/GPTCodeForTerminal/terminal/utils/permission_utils.dart';
import 'package:mek_stripe_terminal/mek_stripe_terminal.dart';
import 'package:permission_handler/permission_handler.dart';

class TerminalFunctions {
  static final termianl_variable_api = StripeApi();
  static Terminal? termianl_variable_terminal;

  static var termianl_variable_locations = <Location>[];
  static Location? termianl_variable_selectedLocation;

  static StreamSubscription? termianl_variable_onConnectionStatusChangeSub;
  static var termianl_variable_connectionStatus = ConnectionStatus.notConnected;
  static bool termianl_variable_isSimulated = true;
  static var _discoveringMethod = DiscoveryMethod.bluetoothScan;
  static StreamSubscription? _discoverReaderSub;
  static var termianl_variable_readers = const <Reader>[];
  static StreamSubscription? termianl_variable_onUnexpectedReaderDisconnectSub;
  static Reader? termianl_variable_reader;

  static StreamSubscription? termianl_variable_onPaymentStatusChangeSub;
  static PaymentStatus termianl_variable_paymentStatus = PaymentStatus.notReady;
  static PaymentIntent? termianl_variable_paymentIntent;
  static CancelableFuture<PaymentIntent>?
      termianl_variable_collectingPaymentMethod;

  // static void dispose() {
  //   // unawaited(termianl_variable_onConnectionStatusChangeSub?.cancel());
  //   // unawaited(_discoverReaderSub?.cancel());
  //   // unawaited(termianl_variable_onUnexpectedReaderDisconnectSub?.cancel());
  //   // unawaited(termianl_variable_onPaymentStatusChangeSub?.cancel());
  //   // unawaited(termianl_variable_collectingPaymentMethod?.cancel());
  // }

  static Future<String> fetchConnectionToken() async =>
      termianl_variable_api.createTerminalConnectionToken();

  static Future<void> initTerminal(Function() update) async {
    final permissions = [
      Permission.locationWhenInUse,
      Permission.bluetooth,
      Permission.bluetoothAdvertise,
      if (Platform.isAndroid) ...[
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
      ],
    ];

    for (final permission in permissions) {
      final status = await permission.request();
      print('$permission: $status');

      if (status == PermissionStatus.denied ||
          status == PermissionStatus.permanentlyDenied) {
        print('Please grant ${permission.name} permission.');
        return;
      }
    }

    if (kReleaseMode) {
      for (final service in permissions.whereType<PermissionWithService>()) {
        final status = await service.serviceStatus;
        print('$service: $status');

        if (status != ServiceStatus.enabled) {
          print('Please enable ${service.name} service.');
          return;
        }
      }
    }

    final terminal = await Terminal.getInstance(
      shouldPrintLogs: false,
      fetchToken: fetchConnectionToken,
    );
    termianl_variable_terminal = terminal;
    termianl_variable_onConnectionStatusChangeSub =
        terminal.onConnectionStatusChange.listen((status) {
      print('Connection Status Changed: ${status.name}');

      termianl_variable_connectionStatus = status;
      if (termianl_variable_connectionStatus == ConnectionStatus.notConnected) {
        termianl_variable_readers = const [];
        termianl_variable_reader = null;
      }
    });
    termianl_variable_onUnexpectedReaderDisconnectSub =
        terminal.onUnexpectedReaderDisconnect.listen((reader) {
      print('Reader Unexpected Disconnected: ${reader.label}');
    });
    termianl_variable_onPaymentStatusChangeSub =
        terminal.onPaymentStatusChange.listen((status) async {
      print('Payment Status Changed: ${status.name}');

      termianl_variable_paymentStatus = status;
      update();
    });
  }

  static void fetchLocations(Terminal terminal) async {
    termianl_variable_locations = const [];
    final locations = await terminal.listLocations();
    termianl_variable_locations = locations;
  }

  static void toggleLocation(Location location) {
    termianl_variable_selectedLocation =
        termianl_variable_selectedLocation == location ? null : location;
  }

  static void changeMode() {
    termianl_variable_isSimulated = !termianl_variable_isSimulated;
    termianl_variable_readers = const [];

    stopDiscoverReaders();
  }

  static void changeDiscoveryMethod(DiscoveryMethod? method) {
    _discoveringMethod = method!;
    termianl_variable_readers = const [];
  }

  static void checkStatus(Terminal terminal) async {
    final status = await terminal.getConnectionStatus();
    print('Connection status: ${status.name}');
  }

  static Future<Reader?> tryConnectReader(
      Terminal terminal, Reader reader) async {
    String? getLocationId() {
      final locationId =
          termianl_variable_selectedLocation?.id ?? reader.locationId;
      if (locationId == null) print('Missing location');
      return locationId;
    }

    switch (_discoveringMethod) {
      case DiscoveryMethod.bluetoothScan || DiscoveryMethod.bluetoothProximity:
        final locationId = getLocationId();
        if (locationId == null) return null;
        return await terminal.connectBluetoothReader(
          reader,
          locationId: locationId,
        );
      case DiscoveryMethod.localMobile:
        final locationId = getLocationId();
        if (locationId == null) return null;
        return await terminal.connectMobileReader(
          reader,
          locationId: locationId,
        );
      case DiscoveryMethod.internet:
        return await terminal.connectInternetReader(reader);
      case DiscoveryMethod.handOff:
        return await terminal.connectHandoffReader(reader);
      case DiscoveryMethod.usb:
        final locationId = getLocationId();
        if (locationId == null) return null;
        return await terminal.connectUsbReader(reader, locationId: locationId);
    }
  }

  static Future<void> connectReader(Terminal terminal, Reader reader,
      Function(bool connected) onconnect) async {
    final connectedReader = await tryConnectReader(terminal, reader);
    onconnect(connectedReader == null ? false : true);
    if (connectedReader == null) {
      return;
    }

    print(
        'Connected to a device: ${connectedReader.label ?? connectedReader.serialNumber}');
    termianl_variable_reader = connectedReader;
  }

  static void disconnectReader(
      Terminal terminal, Function(bool onDisconnect) onDisconnect) async {
    await terminal.disconnectReader();
    termianl_variable_readers = const [];
    termianl_variable_reader = null;
    onDisconnect(true);
    print(
        'Terminal ${termianl_variable_reader!.label ?? termianl_variable_reader!.serialNumber} disconnected');
    termianl_variable_reader = null;
  }

  static void startDiscoverReaders(Terminal terminal, Function update) {
    termianl_variable_readers = const [];

    final configuration = switch (_discoveringMethod) {
      DiscoveryMethod.bluetoothScan => BluetoothDiscoveryConfiguration(
          isSimulated: termianl_variable_isSimulated,
        ),
      DiscoveryMethod.bluetoothProximity =>
        BluetoothProximityDiscoveryConfiguration(
          isSimulated: termianl_variable_isSimulated,
        ),
      DiscoveryMethod.handOff => const HandoffDiscoveryConfiguration(),
      DiscoveryMethod.internet => InternetDiscoveryConfiguration(
          isSimulated: termianl_variable_isSimulated,
        ),
      DiscoveryMethod.localMobile => LocalMobileDiscoveryConfiguration(
          isSimulated: termianl_variable_isSimulated,
        ),
      DiscoveryMethod.usb => UsbDiscoveryConfiguration(
          isSimulated: termianl_variable_isSimulated,
        ),
    };

    final discoverReaderStream = terminal.discoverReaders(configuration);

    _discoverReaderSub = discoverReaderStream.listen((readers) async {
      update();
      termianl_variable_readers = readers;

      if (readers.isNotEmpty) {
        stopDiscoverReaders();
      }
      print('These are the available readers $readers');
    }, onDone: () {
      _discoverReaderSub = null;
      termianl_variable_readers = const [];
    });
  }

  static void stopDiscoverReaders() {
    unawaited(_discoverReaderSub?.cancel());

    // _discoverReaderSub = null;
    // termianl_variable_readers = const [];
  }

  static Future<void> createPaymentIntent(Terminal terminal, int amount) async {
    final paymentIntent =
        await terminal.createPaymentIntent(PaymentIntentParameters(
      amount: amount,
      currency: K.currency,
      captureMethod: CaptureMethod.automatic,
      paymentMethodTypes: [PaymentMethodType.cardPresent],
    ));
    termianl_variable_paymentIntent = paymentIntent;
    print('Payment intent created!');
  }

  static void createFromApiAndRetrievePaymentIntentFromSdk(
      Terminal terminal) async {
    final paymentIntentClientSecret =
        await termianl_variable_api.createPaymentIntent();
    final paymentIntent =
        await terminal.retrievePaymentIntent(paymentIntentClientSecret);
    termianl_variable_paymentIntent = paymentIntent;
    print('Payment intent retrieved!');
  }

  static void collectPaymentMethod(
      Terminal terminal,
      PaymentIntent paymentIntent,
      Function() update,
      Function(bool confirmed) confirmation,
      Function() confirmationStarted) async {
    final collectingPaymentMethod = terminal.collectPaymentMethod(
      paymentIntent,
      skipTipping: true,
    );

    termianl_variable_collectingPaymentMethod = collectingPaymentMethod;

    try {
      update();
      final paymentIntentWithPaymentMethod = await collectingPaymentMethod;
      update();

      termianl_variable_paymentIntent = paymentIntentWithPaymentMethod;
      termianl_variable_collectingPaymentMethod = null;
      update();

      print('Payment method collected!');
      confirmationStarted();
      confirmPaymentIntent(
          termianl_variable_terminal!, termianl_variable_paymentIntent!);

      confirmation(true);
    } on TerminalException catch (exception) {
      termianl_variable_collectingPaymentMethod = null;
      switch (exception.code) {
        case TerminalExceptionCode.canceled:
          print('Collecting Payment method is cancelled!');
        default:
          rethrow;
      }
    }
  }

  static void cancelCollectingPaymentMethod(
      CancelableFuture<PaymentIntent> cancelable) async {
    await cancelable.cancel();
  }

  static void confirmPaymentIntent(
      Terminal terminal, PaymentIntent paymentIntent) async {
    final processedPaymentIntent =
        await terminal.confirmPaymentIntent(paymentIntent);
    termianl_variable_paymentIntent = processedPaymentIntent;
    print('Payment processed!');
  }

  // void print(String message) {
  //   ScaffoldMessenger.of(context)
  //     ..hideCurrentSnackBar()
  //     ..showSnackBar(SnackBar(
  //       behavior: SnackBarBehavior.floating,
  //       content: Text(message),
  //     ));
  // }
}
