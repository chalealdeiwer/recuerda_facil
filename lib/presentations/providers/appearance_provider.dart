import 'package:flutter_riverpod/flutter_riverpod.dart';

final bottomVisibilityProvider = StateProvider<bool>((ref) {
  return true;
});
final clockVisibilityProvider = StateProvider<bool>((ref) {
  return true;
});

final categoriesVisibilityProvider = StateProvider<bool>((ref) {
  return true;
});
final appBarVisibilityProvider = StateProvider<bool>((ref) {
  return true;
});
final buttonNewNoteVisibilityProvider = StateProvider<bool>((ref) {
  return true;
});
final buttonActionVisibilityProvider = StateProvider<bool>((ref) {
  return false;
});
final buttonMicrophoneVisibilityProvider = StateProvider<bool>((ref) {
  return true;
});
final openMenuProvider = StateProvider<bool>((ref) {
  return false;
});
