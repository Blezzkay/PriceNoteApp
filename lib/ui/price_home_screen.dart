import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quote_rate/constants/fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../constants/colors.dart';
import '../controllers/my_projects_controller.dart';
import '../controllers/price_controller.dart';
import '../widgets/item_card_tile.dart';
import 'add_item_screen.dart';

class PriceHomeScreen extends StatelessWidget {
  final String projectId;

  const PriceHomeScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    final PriceController priceController = Get.find<PriceController>();
    final ProjectController projectController = Get.find<ProjectController>();

    // Fetch the project using the ID
    final project = projectController.projects.firstWhere(
          (p) => p.id == projectId,
      orElse: () => throw Exception('Project not found'),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: Obx(() {
        if (priceController.products.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(bottom: 60, right: 5),
          child: FloatingActionButton(
            backgroundColor: brandColor,
            elevation: 0,
            onPressed: () async {
              try {
                await priceController.sharePdf();
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

              // 🔹 Header with back button and project name
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
                    project.title, // Show project name here
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontFamily: figtreeFontBold,
                      color: textDarkColor,
                    ),
                  ),
                  Icon(Icons.settings, color: brandColor, size: 22.sp),
                ],
              ),
              SizedBox(height: 1.h),
              Text(
                'Manage your products and generate price breakdowns for this project',
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
                      color: textDarkColor,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Obx(() {
                    return DropdownButtonHideUnderline(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderLineColor),
                        ),
                        child: DropdownButton<String>(
                          value: priceController.currency.value,
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
                            fontWeight: FontWeight.w500,
                          ),
                          items: priceController.currencySymbols.keys.map((key) {
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
                                  '$key (${priceController.currencySymbols[key]})',
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    color: textDarkColor,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) priceController.setCurrency(value);
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
                    onPressed: () => Get.to(
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
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 2.h),

              Obx(() {
                if (priceController.products.isEmpty) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    "Swipe item left for more options",
                    style: TextStyle(
                      fontFamily: figtreeFontItalic,
                      color: textGreyColor,
                      fontSize: 11,
                    ),
                  ),
                );
              }),

              // 🔸 Scrollable Items List
              Expanded(
                child: Obx(() {
                  return ListView.builder(
                    itemCount: priceController.products.length,
                    itemBuilder: (_, i) {
                      final item = priceController.products[i];
                      return ItemCardTile(
                        title: item.title,
                        amount: item.amount,
                        accentColor: brandColor,
                        type: ItemCardType.product,
                        onEdit: () => Get.to(
                              () => AddItemScreen(
                            type: AddItemType.product,
                            editItem: item,
                          ),
                        ),
                        onDelete: () => priceController.removeProduct(item.id),
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
                      color: borderLineColor,
                      width: 1.5,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.8.h),
                  child: Column(
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                          color: textDarkColor,
                          fontSize: 16.sp,
                          fontFamily: figtreeFontBold,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.center,
                        child: Text(
                          priceController.formattedAmount(priceController.totalAmount),
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
