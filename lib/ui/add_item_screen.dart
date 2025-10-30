import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quote_rate/constants/fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../constants/colors.dart';
import '../controllers/conversion_controller.dart';
import '../controllers/price_controller.dart';
import '../models/conversion_item.dart';
import '../models/product_item.dart';
import '../widgets/simple_labeld_text_form_field.dart';

enum AddItemType { conversion, product }

class AddItemScreen extends StatefulWidget {
  final AddItemType type;
  final dynamic editItem; // Either ConversionItem or ProductItem

  const AddItemScreen({super.key, required this.type, this.editItem});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();

  final ConversionController conversionController = Get.find<ConversionController>();
  final PriceController priceController = Get.find<PriceController>();

  late TextEditingController _titleController;
  late TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
        text: widget.editItem != null ? widget.editItem.title : '');
    _amountController = TextEditingController(
        text: widget.editItem != null ? widget.editItem.amount.toString() : '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;

    final title = _titleController.text.trim();
    final amountText = _amountController.text.trim();
    final amount = int.tryParse(amountText);

    if (amount == null || amount < 0) {
      Get.snackbar('Invalid amount', 'Enter a valid amount');
      return;
    }

    if (widget.type == AddItemType.conversion) {
      final item = widget.editItem != null
          ? ConversionItem(
        id: widget.editItem.id,
        title: title,
        localAmount: amount,
      )
          : ConversionItem.create(title: title, localAmount: amount);

      if (widget.editItem != null) {
        await conversionController.updateItem(item);
      } else {
        await conversionController.addItem(item);
      }
      Get.back(result: item);
    } else {
      final item = widget.editItem != null
          ? ProductItem(
        id: widget.editItem.id,
        title: title,
        amount: amount,
      )
          : ProductItem.create(title: title, amount: amount);

      if (widget.editItem != null) {
        await priceController.updateProduct(item);
      } else {
        await priceController.addProduct(item);
      }
      Get.back(result: item);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEdit = widget.editItem != null;

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.h),

            // 🔹 Header with back button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w,),
              child: Row(
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
                    isEdit ? 'Edit Item' : 'Add Item',
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontFamily: figtreeFontBold,
                      color: textDarkColor,
                    ),
                  ),
                  const SizedBox(width: 22),
                  // Icon(Icons.settings, color: brandColor, size: 22.sp),
                ],
              ),
            ),
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEdit ? 'Edit Item Details' : 'New Item Details',
                      style: TextStyle(
                        fontSize: 17.sp,
                       fontFamily: figtreeFontBold,
                        color: textDarkColor
                      ),
                    ),
                    SizedBox(height: 3.h),

                    // Title Input
                    SimpleLabeledTextFormField(
                      label: 'Item Title',
                      hintText: 'e.g. Products (20 bottles)',
                      controller: _titleController,
                      validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Enter a title' : null,
                    ),
                    SizedBox(height: 2.h),

                    // Amount Input
                    SimpleLabeledTextFormField(
                      label: 'Amount',
                      hintText: 'e.g. 200000',
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Enter a valid amount';
                        }
                        final parsed = int.tryParse(v.trim());
                        if (parsed == null || parsed < 0) {
                          return 'Enter a valid number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 5.h),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      height: 7.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: brandColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 2,
                        ),
                        onPressed: _save,
                        child: Text(
                          isEdit ? 'Save Changes' : 'Add Item',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.sp,
                            fontFamily: figtreeFontBold
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),

                    Center(
                      child: Text(
                        'Your item will be added to the list on the Home Screen.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: textGreyColor,
                          fontSize: 14.sp,
                          fontFamily: figtreeFontItalic
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
