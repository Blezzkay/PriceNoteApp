import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:price_note/constants/fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../constants/colors.dart';
import '../controllers/conversion_controller.dart';
import '../controllers/price_controller.dart';

enum ItemCardType { conversion, product }

class ItemCardTile extends StatelessWidget {
  final String title;
  final int amount; // localAmount for conversion, amount for product
  final Color accentColor;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final ItemCardType type;

  const ItemCardTile({
    super.key,
    required this.title,
    required this.amount,
    required this.accentColor,
    this.onEdit,
    this.onDelete,
    this.type = ItemCardType.conversion,
  });

  @override
  Widget build(BuildContext context) {
    final ConversionController conversionController = Get.find<ConversionController>();
    final PriceController priceController = Get.find<PriceController>();

    return Slidable(
      key: Key(title + amount.toString()),
      endActionPane: ActionPane(
        motion: const DrawerMotion(), // or StretchMotion
        extentRatio: 0.55, // enough space for two actions
        children: [
          SlidableAction(
            onPressed: (_) => onEdit?.call(),
            backgroundColor: accentColor,
            foregroundColor: Colors.white,
            icon: Icons.edit_rounded,
            label: 'Edit',
            borderRadius: BorderRadius.circular(16),
          ),
          SlidableAction(
            onPressed: (_) => onDelete?.call(),
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            icon: Icons.delete_rounded,
            label: 'Delete',
            borderRadius: BorderRadius.circular(16),
          ),
        ],
      ),

      child: Obx(() {
        // Determine displayed values based on type
        String formattedLocal = '';
        String formattedRight = '';
        Color rightBg = accentColor.withOpacity(0.1);
        Color rightTextColor = accentColor;

        if (type == ItemCardType.conversion) {
          formattedLocal = conversionController.formattedLocal(amount);
          formattedRight = conversionController.formattedForeignFromLocal(amount);
          rightBg = lightBrandColor;
          rightTextColor = brandColor;
        } else if (type == ItemCardType.product) {
          formattedRight = priceController.formattedAmount(amount);
          rightBg = lightBrandColor;
          rightTextColor = brandColor;
        }

        return Container(
          margin: EdgeInsets.only(bottom: 1.5.h),
          padding: EdgeInsets.all(16.sp),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color:borderLineColor, width: 1),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.grey.withOpacity(0.08),
            //     blurRadius: 10,
            //     spreadRadius: 1,
            //     offset: const Offset(0, 3),
            //   ),
            // ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 17.sp,
                  fontFamily: figtreeFontMedium,
                  color: textDarkColor
                ),
              ),
              SizedBox(height: 1.h),

              // Local + Foreign row (for conversion)
              if (type == ItemCardType.conversion)
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 8.sp),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          // border: Border.all(color: borderLineColor),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.center,
                          child: Text(
                            formattedLocal,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: notoSansFontRegular,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: textDarkColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 8.sp),
                        decoration: BoxDecoration(
                          color: rightBg,
                          borderRadius: BorderRadius.circular(12),
                          // border: Border.all(color: rightBg.withOpacity(0.7)),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.center,
                          child: Text(
                            formattedRight,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: notoSansFontRegular,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: rightTextColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

              // Product row (for product)
              if (type == ItemCardType.product)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 8.sp),
                      decoration: BoxDecoration(
                        color: rightBg,
                        borderRadius: BorderRadius.circular(12),
                        // border: Border.all(color: rightBg.withOpacity(0.7)),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.center,
                        child: Text(
                          formattedRight,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: notoSansFontRegular,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: rightTextColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      }),
    );
  }
}
