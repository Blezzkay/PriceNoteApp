// 📁 lib/ui/home_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../constants/colors.dart';
import '../constants/fonts.dart';
import 'my_projects_screen.dart';

class MainHomeScreen extends StatelessWidget {
  const MainHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 6.h),

                // Logo / Icon mark
                Container(
                  height: 14.w,
                  width: 14.w,
                  decoration: BoxDecoration(
                    color: brandColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: brandColor.withOpacity(0.25),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.table_chart_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),

                SizedBox(height: 3.h),

                // 👋 Welcome text
                Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 23.sp,
                    fontFamily: figtreeFontBold,
                    color: textDarkColor,
                    letterSpacing: -0.6,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 1.h),

                // Subtitle
                Text(
                  'Select a mode to get started',
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: textGreyColor,
                    fontFamily: figtreeFontRegular,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 6.h),

                // Divider label
                Row(
                  children: [
                    Expanded(child: Divider(color: borderLineColor, thickness: 1)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3.w),
                      child: Text(
                        'MODES',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: figtreeFontSemiBold,
                          color: textGreyColor,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: borderLineColor, thickness: 1)),
                  ],
                ),

                SizedBox(height: 3.h),

                /// 💰 Price Mode Card
                GestureDetector(
                  onTap: () => Get.to(() => MyProjectsScreen()),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 5.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: borderLineColor,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Icon box
                        Container(
                          height: 13.w,
                          width: 13.w,
                          decoration: BoxDecoration(
                            color: brandColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            Icons.table_chart_rounded,
                            color: brandColor,
                            size: 28,
                          ),
                        ),

                        SizedBox(width: 4.w),

                        // Text content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Price Mode',
                                style: TextStyle(
                                  fontSize: 17.sp,
                                  fontFamily: figtreeFontSemiBold,
                                  color: textDarkColor,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              SizedBox(height: 0.6.h),
                              Text(
                                'Input products and prices, generate breakdowns, export PDFs',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: textGreyColor,
                                  fontFamily: figtreeFontRegular,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(width: 3.w),

                        // Arrow
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: textGreyColor,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 6.h),

                // Footer hint
                Text(
                  'More modes coming soon',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: textGreyColor.withOpacity(0.6),
                    fontFamily: figtreeFontRegular,
                    letterSpacing: 0.2,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}