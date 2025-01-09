import 'package:get/get.dart';
import '../../domain/entities/photo_entity.dart';
import '../../domain/repositories/photo_repository.dart';

class HomeController extends GetxController {
  final PhotoRepository _photoRepository;
  final RxList<PhotoEntity> photos = <PhotoEntity>[].obs;
  final RxInt currentIndex = 0.obs;
  final RxBool isLoading = false.obs;

  HomeController(this._photoRepository);

  @override
  void onInit() {
    super.onInit();
    fetchPhotos();
  }

  Future<void> fetchPhotos() async {
    try {
      isLoading.value = true;
      final newPhotos = await _photoRepository.getAllPhotos();
      if (newPhotos.isNotEmpty) {
        photos.assignAll(newPhotos);
        photos.shuffle();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load photos: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void swipeLeft() async {
    if (currentIndex.value < photos.length) {
      try {
        await _photoRepository.deletePhoto(photos[currentIndex.value].path);
        photos.removeAt(currentIndex.value);
        if (photos.isEmpty) {
          Get.snackbar('Complete', 'All photos have been processed');
        }
      } catch (e) {
        Get.snackbar('Error', 'Failed to delete photo: $e');
      }
    }
  }

  void swipeRight() {
    if (currentIndex.value < photos.length) {
      _photoRepository.markPhotoAsViewed(photos[currentIndex.value].id);
      photos.removeAt(currentIndex.value);
      if (photos.isEmpty) {
        Get.snackbar('Complete', 'All photos have been processed');
      }
    }
  }
}
