// conversion_row.dart
// Widget to display a single conversion item row (title, local, foreign).

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../controllers/conversion_controller.dart';
import '../models/conversion_item.dart';

class ConversionRow extends StatelessWidget {
  final ConversionItem item;
  const ConversionRow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final ConversionController c = Get.find<ConversionController>();

    return Card(
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.sp, horizontal: 12.sp),
        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: Text(
                item.title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                c.formattedLocal(item.localAmount), // 🟩 Local currency (e.g. ₦)
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 15.sp),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              flex: 2,
              child: Text(
                c.formattedForeignFromLocal(item.localAmount), // 💵 Foreign currency (e.g. $)
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 15.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
