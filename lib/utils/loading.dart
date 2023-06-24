import 'package:flutter_easyloading/flutter_easyloading.dart';

class Loading {
  static on() => EasyLoading.show(maskType: EasyLoadingMaskType.black);
  static off() => EasyLoading.dismiss();
}
