import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService{
  Future<bool> checkInternet() async {
    bool isConnected = false;
    final List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none) == true) {
      isConnected = false;
    } else {
      isConnected = true;
    }
    return isConnected;
  }
}