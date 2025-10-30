import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../constants/colors.dart';
import '../constants/fonts.dart';
import '../controllers/conversion_controller.dart';
import '../widgets/item_card_tile.dart';
import 'add_item_screen.dart';

class ExchangeScreen extends StatelessWidget {
  const ExchangeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ConversionController c = Get.find<ConversionController>();
    final items = c.items;
    final TextEditingController rateController = TextEditingController(
      text: c.rate.value.toString(),
    );

    const Color backgroundWhite = Colors.white;

    return Scaffold(
      backgroundColor: backgroundWhite,
      floatingActionButton: Obx(() {
        if (c.items.isEmpty) {
          return const SizedBox.shrink(); // Hide FAB when no items
        }

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
              // 🔹 Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: brandColor,
                      size: 18.sp,
                    ),
                  ),
                  Text(
                    'Foreign Price Breakdown',
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontFamily: figtreeFontBold,
                      color: textDarkColor,
                    ),
                  ),
                  Icon(Icons.settings, color: brandColor, size: 22.sp),
                ],
              ),

              SizedBox(height: 0.7.h),
              Text(
                'Set your rate and generate proposal breakdowns easily.',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: textGreyColor,
                  fontFamily: figtreeFontRegular,
                ),
              ),

              SizedBox(height: 2.h),

              // 🔸 Exchange Rate Box
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: backgroundWhite,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderLineColor),

                ),
                padding: EdgeInsets.all(16.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Exchange Rate',
                      style: TextStyle(
                        fontFamily: figtreeFontSemiBold,
                        fontSize: 17.sp,
                        color: textDarkColor,
                      ),
                    ),
                    SizedBox(height: 2.h),

                    // 🔹 Rate Row
                    Row(
                      children: [
                        // Local currency input
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: borderLineColor,
                                  ),
                                ),
                                child: TextField(
                                  controller: rateController,
                                  textAlign: TextAlign.center,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  style: TextStyle(
                                    fontSize: 17.sp,
                                    fontFamily: figtreeFontMedium,
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                  onSubmitted: (value) {
                                    final parsed = double.tryParse(value);
                                    if (parsed == null || parsed <= 0) {
                                      Get.snackbar(
                                        'Invalid rate',
                                        'Enter a number greater than 0',
                                      );
                                      return;
                                    }
                                    c.setRate(parsed);
                                  },
                                ),
                              ),
                              SizedBox(height: 0.8.h),

                              // 🟩 Local currency dropdown
                              Obx(
                                () => DropdownButton<String>(
                                  value: c.localCurrency.value,
                                  underline: const SizedBox(),
                                  onChanged: (val) {
                                    if (val != null) c.setLocalCurrency(val);
                                  },
                                  items:
                                      c.currencySymbols.keys
                                          .map(
                                            (code) => DropdownMenuItem(
                                              value: code,
                                              child: Text(
                                                '$code (${c.currencySymbols[code]})',
                                                style: TextStyle(
                                                  color: textGreyColor,
                                                  fontSize: 15.sp,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: const Text(
                            '≈',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: brandColor
                            ),
                          ),
                        ),

                        // Foreign currency display
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: borderFillColor,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: borderFillColor,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                child: const Center(
                                  child: Text(
                                    '1',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontFamily: figtreeFontMedium,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 0.8.h),

                              // 💵 Foreign currency dropdown
                              Obx(
                                () => DropdownButton<String>(
                                  value: c.foreignCurrency.value,
                                  underline: const SizedBox(),
                                  onChanged: (val) {
                                    if (val != null) c.setForeignCurrency(val);
                                  },
                                  items:
                                      c.currencySymbols.keys
                                          .map(
                                            (code) => DropdownMenuItem(
                                              value: code,
                                              child: Text(
                                                '$code (${c.currencySymbols[code]})',
                                                style: TextStyle(
                                                  color: textGreyColor,
                                                  fontSize: 15.sp,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 3.h),

              // 🔹 Items Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Items',
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontFamily: figtreeFontMedium,
                      color: textDarkColor,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed:
                        () => Get.to(
                          () =>
                              const AddItemScreen(type: AddItemType.conversion),
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
                if (c.items.isEmpty) return const SizedBox.shrink();
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
                    itemCount: items.length,
                    itemBuilder: (_, i) {
                      final item = items[i];
                      return ItemCardTile(
                        title: item.title,
                        amount: item.localAmount, // Conversion local amount
                        accentColor: brandColor,
                        type: ItemCardType.conversion, // specify conversion
                        onEdit: () {
                          Get.to(
                            () => AddItemScreen(
                              type: AddItemType.conversion,
                              editItem: item,
                            ),
                          );
                        },
                        onDelete: () => c.removeItem(item.id),
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
                      SizedBox(height: 1.h),
                      Row(
                        children: [
                          // Local total
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                c.formattedLocal(c.totalLocal),
                                style: TextStyle(
                                  fontFamily: notoSansFontRegular,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: textDarkColor,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: 4.w),

                          // Foreign total
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: brandColor,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 5.w,
                                vertical: 1.2.h,
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.center,
                                child: Text(
                                  c.formattedForeignFromLocal(c.totalLocal),
                                  style:  TextStyle(
                                    fontFamily: notoSansFontRegular,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                  ),
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
            ],
          ),
        ),
      ),
    );
  }
}
