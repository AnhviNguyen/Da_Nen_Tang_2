abstract class FileStorageService {
  Future<String> saveImageToLocal(String sourcePath);
  Future<void> deleteImageFile(String filePath);
  Future<bool> fileExists(String filePath);
}
