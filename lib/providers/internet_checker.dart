import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class InternetCheker extends StateNotifier<bool> {
  InternetCheker() : super(true) {
    _init();
  }

  void _init() {
    Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      state = results.any((result) => result != ConnectivityResult.none);
    });
  }
}

final internetChecker = StateNotifierProvider<InternetCheker, bool>((ref) {
  return InternetCheker();
});
