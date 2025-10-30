import 'dart:io';
import 'package:path/path.dart' as path;  // ← THÊM "as path"
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_gallery_app/repository/FileStorageService.dart';

class FileStorageServiceImpl implements FileStorageService {
  @override
  Future<String> saveImageToLocal(String sourcePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = path.basename(sourcePath);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final newPath = path.join(directory.path, '${timestamp}_$fileName');

    final sourceFile = File(sourcePath);
    await sourceFile.copy(newPath);

    return newPath;
  }

  @override
  Future<void> deleteImageFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      debugPrint('Error deleting file: $e');
    }
  }

  @override
  Future<bool> fileExists(String filePath) async {
    return await File(filePath).exists();
  }
}