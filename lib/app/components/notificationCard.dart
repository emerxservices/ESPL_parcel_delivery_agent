import 'package:espl_parcel_driver/app/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationCard extends StatelessWidget {
  NotificationCard(
      {required this.title,
      required this.description,
      required this.createdOnDate});
  String title;
  String description;
  String createdOnDate;
  String? formattedDate;

  void result() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    final dateToCheck = DateTime.parse(
        createdOnDate); //if date in 2023-02-16T13:13:21.504Z format
    final aDate =
        DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day);

    if (aDate == today) {
      formattedDate = "Today";
    } else if (aDate == yesterday) {
      formattedDate = "Yesterday";
    } else {
      var formatter = DateFormat('dd/MM/yyyy');
      var formatted = formatter.format(aDate);
      formattedDate = "$formatted";
    }
  }

  @override
  Widget build(BuildContext context) {
    // DateTime now = DateTime.parse('2022-08-29T10:33:49.283Z');
    result();
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      child: IntrinsicHeight(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0)),
                color: inActiveGrey,
              ),
              padding: const EdgeInsets.only(
                  left: 30.0, top: 20.0, right: 20.0, bottom: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: kText16w700.copyWith(color: Colors.black),
                        ),
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Text(
                        formattedDate!,
                        style: kText14w400.copyWith(
                          fontWeight: FontWeight.w700,
                          color: lightGreySecondary,
                        ),
                        maxLines: 1,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text(description,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: kText14w400.copyWith(
                        color: lightGreySecondary,
                      ))
                ],
              ),
            ),
            Container(
              width: 10,
              decoration: const BoxDecoration(
                  color: orange,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0))),
            ),
          ],
        ),
      ),
    );
  }
}
