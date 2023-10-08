import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectionStatusProvider = Provider.autoDispose<ConnectionStatusNotifier>((ref) {
  return ConnectionStatusNotifier()..checkCurrentStatus();
});

class ConnectionStatusNotifier extends StateNotifier<bool> {
  ConnectionStatusNotifier() : super(false) {
    _init();
  }

  final Dio _dio = Dio();

  Future<void> _init() async {
    Connectivity().onConnectivityChanged.listen((result) async {
      if (result != ConnectivityResult.none) {
        await checkCurrentStatus();
      } else {
        state = false;
      }
    });
  }

  Future<void> checkCurrentStatus() async {
    try {
      final result = await _dio.get('https://jsonplaceholder.typicode.com/posts/1');
      if (result.statusCode == 200) {
        state = true;
      } else {
        state = false;
      }
    } catch (e) {
      state = false;
    }
  }
}