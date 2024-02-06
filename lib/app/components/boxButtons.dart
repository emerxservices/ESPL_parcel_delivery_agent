import 'package:espl_parcel_driver/app/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class BoxButtons extends StatelessWidget {
  BoxButtons(
      {required this.title,
      required this.goto,
      this.onUpdateProfileData,
      required this.dataUploaded});

  String title;
  String goto;
  bool dataUploaded;
  Function? onUpdateProfileData;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      height: 55.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(width: 1, color: inActiveGrey)),
      child: TextButton(
        style: TextButton.styleFrom(
            foregroundColor: orangeOverlayPrimary, // Text Color
            fixedSize: Size.fromHeight(55)),
        onPressed: () async {
          var result = await Get.toNamed(goto);
          print('Get back result : $result');
          if (result == "updated") {
            onUpdateProfileData!();
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  dataUploaded == true
                      ? const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        )
                      : const Icon(
                          Icons.description,
                          color: Colors.black,
                        ),
                  const SizedBox(
                    width: 16.0,
                  ),
                  Expanded(
                    child: Text(
                      title,
                      style: kText18w600.copyWith(color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 16.0,
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }
}
