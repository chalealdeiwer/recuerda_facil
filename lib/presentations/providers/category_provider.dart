import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryProvider = StateProvider<String>((ref) => 'Todos');
final indexCategoryProvider = StateProvider<int>((ref) => 0);
