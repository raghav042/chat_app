// lib/core/network/connectivity_provider.dart

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityStatusProvider =
    StreamProvider<List<ConnectivityResult>>((ref) {
  return Connectivity().onConnectivityChanged;
});

final isConnectedProvider = Provider<bool>((ref) {
  final status = ref.watch(connectivityStatusProvider).value;
  return status?[0] != ConnectivityResult.none;
});
