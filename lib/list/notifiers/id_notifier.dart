import 'package:hooks_riverpod/hooks_riverpod.dart';

class IdNotifier extends StateNotifier<String> {
  IdNotifier() : super("");

  void update(String newKey) {
    state = newKey;
  }
}

final idProvider = StateNotifierProvider<IdNotifier, String>((ref) {
  return IdNotifier();
});
