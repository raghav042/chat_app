// lib/core/connectivity/connectivity_bloc.dart

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'connectivity_event.dart';
import 'connectivity_state.dart';
import 'connectivity_service.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final ConnectivityService connectivityService;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  ConnectivityBloc(this.connectivityService) : super(ConnectivityInitial()) {
    on<ConnectivityChanged>((event, emit) {
      final hasConnection = event.results.any((result) => result != ConnectivityResult.none);
      if (hasConnection) {
        emit(ConnectivityOnline());
      } else {
        emit(ConnectivityOffline());
      }
    });

    _init();
  }

  Future<void> _init() async {
    _subscription = connectivityService.onConnectivityChanged.listen((resultList) {
      add(ConnectivityChanged(resultList));
    });

    final result = await connectivityService.checkConnectivity();
    add(ConnectivityChanged(result));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}