import 'dart:io';
import 'package:file_picker/file_picker.dart';
import '../../domain/entities/photo_entity.dart';
import '../../domain/repositories/photo_repository.dart';

class PhotoRepositoryWindowsImpl implements PhotoRepository {
  @override
  Future<List<PhotoEntity>> getAllPhotos() async {
    try {
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
      if (selectedDirectory == null) return [];

      final dir = Directory(selectedDirectory);
      final List<FileSystemEntity> entities =
          await dir.list(recursive: true).toList();

      final imageFiles = entities.whereType<File>().where((file) {
        final extension = file.path.toLowerCase();
        return extension.endsWith('.jpg') ||
            extension.endsWith('.jpeg') ||
            extension.endsWith('.png') ||
            extension.endsWith('.gif');
      }).toList();

      return imageFiles
          .map((file) => PhotoEntity(
                id: file.path,
                path: file.path,
                createDate: file.lastModifiedSync(),
              ))
          .toList();
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
    // Store viewed photos in local storage if needed
  }
}
