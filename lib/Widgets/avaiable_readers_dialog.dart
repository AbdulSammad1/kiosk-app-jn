import 'package:flutter/material.dart';
import 'package:kiosk_app/Widgets/terminal_functions.dart';
import 'package:kiosk_app/constants.dart';
import 'package:mek_stripe_terminal/mek_stripe_terminal.dart';

class AvailableReadersDialog extends StatefulWidget {
  const AvailableReadersDialog({super.key});

  @override
  State<AvailableReadersDialog> createState() => _AvailableReadersDialogState();
}

class _AvailableReadersDialogState extends State<AvailableReadersDialog> {
  bool isLoading = true;
  bool connecting = false;
  String serialNumberOfConnectingDevice = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initilize();
  }

  void initilize() {
    if (TerminalFunctions.termianl_variable_reader == null) {
      TerminalFunctions.startDiscoverReaders(
          TerminalFunctions.termianl_variable_terminal!, () {
        setState(() {
          isLoading = false;

          print('status of loading $isLoading');
        });
      });
    }
    // setState(() {
    //   isLoading = false;
    //   print('status of loading $isLoading');
    // });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(size.height * 0.01)),
      title: Text(
        'Available Readers',
        style: TextStyle(fontSize: size.height * 0.03),
      ),
      content: SizedBox(
        height: size.height * 0.4,
        width: size.width * 0.8,
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              )
            : Column(
                children: TerminalFunctions.termianl_variable_readers
                    .map((e) => Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: ListTile(
                            selectedTileColor: Colors.green.withOpacity(0.2),
                            selected: e.serialNumber ==
                                TerminalFunctions
                                    .termianl_variable_reader?.serialNumber,
                            enabled: TerminalFunctions
                                        .termianl_variable_terminal !=
                                    null &&
                                TerminalFunctions
                                        .termianl_variable_connectionStatus !=
                                    ConnectionStatus.connecting &&
                                (TerminalFunctions.termianl_variable_reader ==
                                        null ||
                                    TerminalFunctions.termianl_variable_reader!
                                            .serialNumber ==
                                        e.serialNumber),
                            onTap: connecting
                                ? null
                                : TerminalFunctions
                                            .termianl_variable_connectionStatus ==
                                        ConnectionStatus.notConnected
                                    ? () async {
                                        setState(() {
                                          connecting = true;
                                          serialNumberOfConnectingDevice =
                                              e.serialNumber;
                                        });
                                        await TerminalFunctions.connectReader(
                                            TerminalFunctions
                                                .termianl_variable_terminal!,
                                            e, (onConnect) {
                                          setState(() {});
                                          serialNumberOfConnectingDevice = '';
                                          connecting = false;
                                          // Navigator.of(context).pop();
                                          // Constants().showDialogBox(
                                          //     context,
                                          //     onConnect
                                          //         ? 'Connected Successfully'
                                          //         : 'Something went wrong',
                                          //     onConnect
                                          //         ? 'You are connected to the reader: ${TerminalFunctions.termianl_variable_reader!.label}'
                                          //         : 'Please try again');
                                        });
                                      }
                                    : TerminalFunctions
                                                .termianl_variable_reader !=
                                            null
                                        ? TerminalFunctions
                                                    .termianl_variable_reader!
                                                    .serialNumber ==
                                                e.serialNumber
                                            ? () {
                                                TerminalFunctions.disconnectReader(
                                                    TerminalFunctions
                                                        .termianl_variable_terminal!,
                                                    (onDisconnect) {
                                                  Navigator.of(context).pop();
                                                  Constants().showDialogBox(
                                                      context,
                                                      'Disconnected Successfully',
                                                      'The reader was disconnected Successfully');
                                                });
                                              }
                                            : () {
                                                Constants().showDialogBox(
                                                    context,
                                                    'Already Connected',
                                                    'A device is already connected kindly dissconnect first');
                                              }
                                        : null,
                            title: Text(
                              e.serialNumber,
                              style: TextStyle(fontSize: size.height * 0.015),
                            ),
                            subtitle: Text(
                                '${e.deviceType?.name ?? 'Unknown'} Status: ${e.serialNumber == serialNumberOfConnectingDevice ? 'Connecting' : TerminalFunctions.termianl_variable_terminal != null && TerminalFunctions.termianl_variable_reader != null && TerminalFunctions.termianl_variable_reader!.serialNumber == e.serialNumber ? 'Connected' : 'Not Connected'}',
                                style:
                                    TextStyle(fontSize: size.height * 0.012)),
                            trailing: Text(
                                'Battery: ${(e.batteryLevel * 100).toInt()}%',
                                style:
                                    TextStyle(fontSize: size.height * 0.012)),
                          ),
                        ))
                    .toList(),
              ),
      ),
    );
  }
}
