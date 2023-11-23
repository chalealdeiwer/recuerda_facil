
import 'package:flutter_riverpod/flutter_riverpod.dart';

final textProvider = StateProvider<String>((ref) => 'Mantén presionado el botón para iniciar el reconocimiento de voz');
final isListeningProvider = StateProvider<bool>((ref) => false);

