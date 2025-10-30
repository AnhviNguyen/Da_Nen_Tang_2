abstract class ImageService {
  Future<String?> pickImageFromCamera();
  Future<String?> pickImageFromGallery();
  Future<bool> requestCameraPermission();
  Future<bool> requestStoragePermission();
}