import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

enum NetworkStatus { offline, online }

class CheckConnect extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  StreamController<NetworkStatus> connection =
      StreamController<NetworkStatus>();

  CheckConnect() {
    _connectivity.onConnectivityChanged.listen((event) {
      if (event.first == ConnectivityResult.mobile ||
          event.first == ConnectivityResult.wifi) {
        connection.add(NetworkStatus.online);
      } else {
        connection.add(NetworkStatus.offline);
      }
    });
  }
  Stream<NetworkStatus> get statusStream => connection.stream;
// void dispose() {
//     connection.close();
//   }
}
