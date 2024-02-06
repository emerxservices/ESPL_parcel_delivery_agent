import 'package:espl_parcel_driver/app/services/imagePicker.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:image_picker/image_picker.dart';

class ActionSheet {
  ImagePickerServices imagePicker = ImagePickerServices();

  showActionSheet(dynamic context) {
    showAdaptiveActionSheet(
      context: context,
      androidBorderRadius: 30,
      actions: <BottomSheetAction>[
        BottomSheetAction(
            leading: Icon(Icons.image),
            title: const Text('Pick from gallery'),
            onPressed: (context) {
              imagePicker.getImage(ImageSource.gallery);
              Navigator.pop(context);
            }),
        BottomSheetAction(
            leading: Icon(Icons.camera),
            title: const Text('Pick from camera'),
            onPressed: (context) {
              imagePicker.getImage(ImageSource.camera);
              Navigator.pop(context);
            }),
      ],
    );
  }
}
