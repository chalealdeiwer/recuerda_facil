import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recuerda_facil/models/user_account.dart';
import 'package:recuerda_facil/services/user_services.dart';

// final userProviderr = FutureProvider.family<UserAccount?, String>((ref, uid) async {
//   return await getUser(uid);
// });
final userProviderr = StreamProvider.family<UserAccount?, String>((ref, uid) {
  return getUserStream(uid);
});