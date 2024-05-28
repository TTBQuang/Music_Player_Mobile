import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:music_player/utils/size_config.dart';

import '../../utils/strings.dart';

enum ConnectionStatus {
  connected,
  disconnected,
}

class BaseScreen extends StatefulWidget {

  final Widget Function() buildScreenContent;

  @override
  State<StatefulWidget> createState() => _BaseScreenState();

  const BaseScreen(this.buildScreenContent, {super.key});
}

class _BaseScreenState extends State<BaseScreen> {
  late StreamSubscription<List<ConnectivityResult>> subscription;
  ConnectionStatus connectionStatus = ConnectionStatus.connected;

  @override
  void initState() {
    super.initState();

    // Listen to change in network connection status
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      setState(() {
        // Update network connection status
        connectionStatus = _getConnectionStatus(result);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show screen base on network connection status
    if (connectionStatus == ConnectionStatus.connected) {
      return widget.buildScreenContent();
    } else {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/image/wifi_off.png',
              width: SizeConfig.screenWidth * 5 / 7,
              height: SizeConfig.screenHeight / 4),
            Text(Strings.loseNetworkConnection, style: TextStyle(fontSize: 18.w))
          ],),
        ),
      );
    }
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  // Determines the network connection status from the ConnectivityResult list
  ConnectionStatus _getConnectionStatus(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.mobile)) {
      return ConnectionStatus.connected;
    } else {
      return ConnectionStatus.disconnected;
    }
  }
}
