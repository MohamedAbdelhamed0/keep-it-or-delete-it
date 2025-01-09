import 'package:photo_manager/photo_manager.dart';
import 'package:getxpractice/domain/entities/photo_entity.dart';
import 'package:getxpractice/domain/repositories/photo_repository.dart';

class PhotoRepositoryImpl implements PhotoRepository {
  @override
  Future<List<PhotoEntity>> getAllPhotos() async {
    final result = await PhotoManager.requestPermissionExtend();
    if (result.isAuth) {
      final albums = await PhotoManager.getAssetPathList(onlyAll: true);
      final photos = await albums[0].getAssetListPaged(page: 0, size: 1000);
      return photos
          .map((asset) => PhotoEntity(
                id: asset.id,
                path: asset.relativePath ?? '',
                createDate: asset.createDateTime,
              ))
          .toList();
    } else {
      throw Exception('Permission denied');
    }
  }

  @override
  Future<void> deletePhoto(String path) async {
    // Implement deletion logic using PhotoManager
    await PhotoManager.editor.deleteWithIds([path]);
  }

  @override
  Future<void> markPhotoAsViewed(String id) async {
    // Implement mark as viewed logic
  }
}
