import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/providers.dart';

class TestScreen extends ConsumerWidget {
  static const name = 'test_screen';

  const TestScreen({super.key});

  @override
  Widget build(BuildContext context,  ref) {
    final connectionStatus = ref.watch(connectionStatusProvider).state;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Screen'),
      ),
      body: Center(
        child: connectionStatus
            ? const Text(
                'Estás conectado a Internet',
                style: TextStyle(fontSize: 20, color: Colors.green),
              )
            : const Text(
                'No estás conectado a Internet',
                style: TextStyle(fontSize: 20, color: Colors.red),
              ),
      ),
    );
  }
}