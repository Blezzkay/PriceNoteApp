import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../constants/colors.dart';
import '../constants/fonts.dart';
import '../controllers/my_projects_controller.dart';
import '../widgets/simple_labeld_text_form_field.dart';

void showCreateProjectSheet(BuildContext context) {
  final ProjectController c = Get.find<ProjectController>();
  final _formKey = GlobalKey<FormState>();

  Get.bottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(22.sp),
          topRight: Radius.circular(22.sp),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Create New Project",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontFamily: figtreeFontBold,
                        color: textDarkColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Icon(Icons.close, size: 24.sp),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),

                // Project Name
                SimpleLabeledTextFormField(
                  label: 'Project Name *',
                  hintText: 'Enter project name',
                  controller: c.projectNameController,
                  validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Enter a project name' : null,
                ),
                SizedBox(height: 2.h),

                // Description
                SimpleLabeledTextFormField(
                  label: 'Description',
                  hintText: 'Enter project description',
                  controller: c.descriptionController,
                  validator: (v) => null,
                ),
                SizedBox(height: 2.h),

                // Bank Details
                SimpleLabeledTextFormField(
                  label: 'Bank Details (optional)',
                  hintText: 'Enter your Bank Account details to receive payments',
                  controller: c.bankDetailsController,
                  validator: (v) => null,
                  isMultiline: true,
                ),
                SizedBox(height: 2.h),

                // Brand Logo Upload (unchanged)
                Text(
                  'Brand Logo (optional)',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: figtreeFontSemiBold,
                    color: textDarkColor,
                  ),
                ),
                SizedBox(height: 1.h),
                Container(
                  height: 15.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12.sp),
                  ),
                  child: Center(
                    child: Text(
                      'Upload Logo',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: figtreeFontRegular,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 3.h),

                // SAVE BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 7.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: brandColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.sp),
                      ),
                      elevation: 2,
                    ),
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) return;

                      // Call controller's createProject function
                      c.createProject(context);
                    },
                    child: Text(
                      'Create Project',
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontFamily: figtreeFontBold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),

                Center(
                  child: Text(
                    'This project will be added to your list of Projects.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: figtreeFontItalic,
                      color: textGreyColor,
                    ),
                  ),
                ),
                SizedBox(height: 3.h),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
