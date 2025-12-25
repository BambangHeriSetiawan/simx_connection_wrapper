import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:http/http.dart' as http;

enum InternetConnectionStatus { connected, disconnected }

class InternetConnectionNotifier
    extends StateNotifier<InternetConnectionStatus> {
  InternetConnectionNotifier() : super(InternetConnectionStatus.disconnected) {
    _startListening();
  }

  final Connectivity _connectivity = Connectivity();
  final http.Client _httpClient = http.Client();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  Future<void> _startListening() async {
    // Cek koneksi awal
    await _checkInternetConnectivity();

    // Listen ke perubahan koneksi jaringan
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((result) async {
      await _checkInternetConnectivity();
    });
  }

  Future<void> checkNow() async {
      await _checkInternetConnectivity();
    }

  Future<void> _checkInternetConnectivity() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      debugPrint('Connectivity Result: $connectivityResult');
      // Jika tidak ada koneksi jaringan
      if (connectivityResult == ConnectivityResult.none) {
        state = InternetConnectionStatus.disconnected;
        return;
      }

      // Coba akses ke internet dengan HTTP ping
      final response = await _httpClient.get(
        Uri.parse('https://httpbin.org/get'),
        headers: {'User-Agent': 'FlutterApp/1.0'},
      );

      if (response.statusCode == 200) {
        state = InternetConnectionStatus.connected;
      } else {
        state = InternetConnectionStatus.disconnected;
      }
    } catch (e) {
      state = InternetConnectionStatus.disconnected;
    }
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    _httpClient.close();
    super.dispose();
  }
}

// Provider global
final internetConnectionProvider =
    StateNotifierProvider<InternetConnectionNotifier, InternetConnectionStatus>(
      (ref) => InternetConnectionNotifier(),
    );
