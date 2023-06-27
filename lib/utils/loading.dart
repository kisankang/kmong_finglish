import 'package:flutter_easyloading/flutter_easyloading.dart';

class Loading {
  static on() => EasyLoading.show(maskType: EasyLoadingMaskType.black);
  static off() => EasyLoading.dismiss();
  static onWithProgress() =>
      EasyLoading.showProgress(0, maskType: EasyLoadingMaskType.black);
  static updateProgress(double done, {required String status}) {
    EasyLoading.instance.progressKey?.currentState?.updateProgress(done);
    EasyLoading.instance.key?.currentState?.updateStatus(status);
  }
}
