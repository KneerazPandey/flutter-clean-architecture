import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_clean_architecture/core/network/network_info.dart';

class NetworkInfoImpl implements NetworkInfo {
  late Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final ConnectivityResult connectivityResult =
        await connectivity.checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) return false;
    return true;
  }
}
