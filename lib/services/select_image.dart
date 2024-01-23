import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

Future getImage() async {
  final ImagePicker picker = ImagePicker();
  final XFile? image =await picker.pickImage(source: ImageSource.gallery);
  return image;
}

