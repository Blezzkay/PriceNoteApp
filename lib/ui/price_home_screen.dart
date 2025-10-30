import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quote_rate/constants/fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../constants/colors.dart';
import '../controllers/price_controller.dart';
import '../widgets/item_card_tile.dart';
import 'add_item_screen.dart';

class PriceHomeScreen extends StatelessWidget {
  const PriceHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PriceController c = Get.find<PriceController>();

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: Obx(() {
        if (c.products.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(bottom: 60, right: 5),
          child: FloatingActionButton(
            backgroundColor: brandColor,
            elevation: 0,
            onPressed: () async {
              try {
                await c.sharePdf();
              } catch (e) {
                Get.snackbar('Export failed', e.toString());
              }
            },
            child: const Icon(Icons.picture_as_pdf, color: Colors.white),
          ),
        );
      }),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 2.h),

              // 🔹 Header with back button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: brandColor,
                      size: 18.sp,
                    ),
                  ),
                  Text(
                    'Create Price Breakdown',
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontFamily: figtreeFontBold,
                      color: textDarkColor,
                    ),
                  ),
                  // const SizedBox(width: 22),
                  Icon(Icons.settings, color: brandColor, size: 22.sp),
                ],
              ),
              SizedBox(height: 1.h),
              Text(
                'Manage your products and generate price breakdowns easily',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: textGreyColor,
                  fontFamily: figtreeFontRegular,
                ),
              ),
              SizedBox(height: 2.h),

              // 🔹 Currency Dropdown
              Row(
                children: [
                  Text(
                    'Currency ',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: figtreeFontMedium,
                      color: textDarkColor
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Obx(() {
                    return DropdownButtonHideUnderline(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderLineColor),

                        ),
                        child: DropdownButton<String>(
                          value: c.currency.value,
                          dropdownColor: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          elevation: 0,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: brandColor,
                            size: 20.sp,
                          ),
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: textDarkColor,
                            fontWeight: FontWeight.w500
                          ),
                          items:
                              c.currencySymbols.keys.map((key) {
                                return DropdownMenuItem(
                                  value: key,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 1.h,
                                      horizontal: 2.w,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      // key,
                                      '$key (${c.currencySymbols[key]})',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        color: textDarkColor,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                          onChanged: (value) {
                            if (value != null) c.setCurrency(value);
                          },
                        ),
                      ),
                    );
                  }),
                ],
              ),

              SizedBox(height: 3.h),

              // 🔹 Items Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Products',
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontFamily: figtreeFontMedium,
                      color: textDarkColor,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed:
                        () => Get.to(
                          () => const AddItemScreen(type: AddItemType.product),
                        ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: brandColor,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.sp,
                        vertical: 1.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text(
                      'Add Item',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: figtreeFontSemiBold,
                        letterSpacing: -0.3
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 2.h),

              Obx(() {
                if (c.products.isEmpty) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    "Swipe item left for more options",
                    style: TextStyle(
                      fontFamily: figtreeFontItalic,
                      color: textGreyColor,
                      fontSize: 11
                    ),

                  )
                );
              }),

              // 🔸 Scrollable Items List
              Expanded(
                child: Obx(() {
                  return ListView.builder(
                    itemCount: c.products.length,
                    itemBuilder: (_, i) {
                      final item = c.products[i];
                      return ItemCardTile(
                        title: item.title,
                        amount: item.amount, // Product amount
                        accentColor: brandColor,
                        type: ItemCardType.product, // specify product
                        onEdit: () {
                          Get.to(
                            () => AddItemScreen(
                              type: AddItemType.product,
                              editItem: item,
                            ),
                          );
                        },
                        onDelete: () => c.removeProduct(item.id),
                      );
                    },
                  );
                }),
              ),

              // 🔹 Total Section
              Obx(() {
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    border: Border.all(
                      color: borderLineColor, // light grey border
                      width: 1.5,                   // slightly thicker for visibility
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.w,
                    vertical: 1.8.h,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                          color: textDarkColor,
                          fontSize: 16.sp,
                          fontFamily: figtreeFontBold
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.center,
                        child: Text(
                          c.formattedAmount(c.totalAmount),
                          style: TextStyle(
                            fontFamily: notoSansFontRegular,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: textDarkColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
