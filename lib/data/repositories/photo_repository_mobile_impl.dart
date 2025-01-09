import 'dart:io';
import 'package:file_picker/file_picker.dart';
import '../../domain/entities/photo_entity.dart';
import '../../domain/repositories/photo_repository.dart';

class PhotoRepositoryMobileImpl implements PhotoRepository {
  @override
  Future<List<PhotoEntity>> getAllPhotos() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );

      if (result == null) return [];

      return result.files.map((file) {
        return PhotoEntity(
          id: file.path!,
          path: file.path!,
          createDate: DateTime.now(),
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to load images: $e');
    }
  }

  @override
  Future<void> deletePhoto(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      throw Exception('Failed to delete file: $e');
    }
  }

  @override
  Future<void> markPhotoAsViewed(String id) async {
    // Implement using SharedPreferences if needed
  }
}
