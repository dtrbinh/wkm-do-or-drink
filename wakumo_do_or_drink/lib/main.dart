import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakumo_do_or_drink/features/do_or_drink_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android) {
    // Some android/ios specific code
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
  else if (defaultTargetPlatform == TargetPlatform.linux || defaultTargetPlatform == TargetPlatform.macOS || defaultTargetPlatform == TargetPlatform.windows) {
    // Some desktop specific code there
  }
  else {
    // Some web specific code there
  }

  runApp(const DoOrDrinkApp());
}
