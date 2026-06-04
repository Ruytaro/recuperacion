import 'package:image_picker/image_picker.dart';

class GalleryService {
  final ImagePicker _picker = ImagePicker();

  Future<String?> selectPhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
    if (photo == null) return null;
    return photo.path;
  }

  Future<String?> takePhoto() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
    );
    if (photo == null) return null;
    return photo.path;
  }
}
