import '../entities/photo_entity.dart';

abstract class PhotoRepository {
  Future<List<PhotoEntity>> getAllPhotos();
  Future<void> deletePhoto(String path);
  Future<void> markPhotoAsViewed(String id);
}
