import 'package:get/get.dart';
import 'package:getxpractice/data/repositories/photo_repository_mobile_impl.dart';
import 'package:getxpractice/data/repositories/photo_repository_windows_impl.dart';
import 'package:getxpractice/domain/repositories/photo_repository.dart';
import 'package:getxpractice/presentation/controllers/home_controller.dart';
import 'dart:io' show Platform;

class DependencyInjection {
  static void init() {
    if (Platform.isWindows) {
      Get.lazyPut<PhotoRepository>(() => PhotoRepositoryWindowsImpl());
    } else {
      Get.lazyPut<PhotoRepository>(() => PhotoRepositoryMobileImpl());
    }
    Get.lazyPut<HomeController>(() => HomeController(Get.find()));
  }
}
