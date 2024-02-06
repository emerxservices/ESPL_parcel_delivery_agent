import 'dart:io';
import 'dart:async';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';

import '../modules/profile_setup/controllers/profile_setup_controller.dart';

class ImagePickerServices extends GetView<ProfileSetupController> {
  static File? imagePath;

  Future getImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);

      if (image == null) return;

      final imagePermanent = File(image.path);
      compressImage(image.path);

      imagePath = imagePermanent;
    } catch (e) {
      print(e);
    }
    print('====================== $imagePath');
  }

  Future compressImage(imagePath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      imagePath,
      imagePath + 'compressed.jpg',
      quality: 50,
    );
    controller.temporaryImage.value = result!.path.toString();

    print(result.path);
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
