import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../constants/colors.dart';
import '../controllers/conversion_controller.dart';
import '../controllers/price_controller.dart';
import '../models/conversion_item.dart';
import '../models/product_item.dart';

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
      // ConversionItem
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
      // ProductItem
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
    final Color themeColor = brandColor;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          isEdit ? 'Edit Item' : 'Add Item',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 2.h),

              // Title Input
              Container(
                padding: EdgeInsets.all(14.sp),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Item Title',
                    hintText: 'e.g. Products (20 bottles)',
                    border: InputBorder.none,
                  ),
                  inputFormatters: [LengthLimitingTextInputFormatter(60)],
                  validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Enter a title' : null,
                ),
              ),
              SizedBox(height: 2.h),

              // Amount Input
              Container(
                padding: EdgeInsets.all(14.sp),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    hintText: 'e.g. 200000',
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
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
              ),
              SizedBox(height: 5.h),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 7.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
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
                      fontWeight: FontWeight.bold,
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
                    color: Colors.grey.shade600,
                    fontSize: 15.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
