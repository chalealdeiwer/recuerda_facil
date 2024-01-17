import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectionStatusProvider = StateNotifierProvider<ConnectionStatusNotifier,ConnectionStatus>((ref) {
  return ConnectionStatusNotifier();
});

class ConnectionStatusNotifier extends StateNotifier<ConnectionStatus> {

  ConnectionStatusNotifier() : super(ConnectionStatus()) {
    check();
    checkCurrentStatus();
    
  }

  final Dio _dio = Dio();

  Future<void> check() async {
    Connectivity().onConnectivityChanged.listen((result) async {
      if (result != ConnectivityResult.none) {
        await checkCurrentStatus();
      } else {
        state=state.copyWith(isConnected: false);
      }
    });
  }

  Future<void> checkCurrentStatus() async {
    try {
      final result = await _dio.get('https://jsonplaceholder.typicode.com/posts/1');
      if (result.statusCode == 200) {
        state=state.copyWith(isConnected: true);
      } else {
        state=state.copyWith(isConnected: false);
      }
    } catch (e) {
      state=state.copyWith(isConnected: false);
    }
  }
}
class ConnectionStatus {
  final bool? isConnected;
  ConnectionStatus({this.isConnected=false});

  ConnectionStatus copyWith({
    bool? isConnected,
  })=> ConnectionStatus( 
    isConnected: isConnected ?? this.isConnected,
  );
  }

