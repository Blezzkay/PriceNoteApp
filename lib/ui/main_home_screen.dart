// 📁 lib/ui/home_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../constants/colors.dart';
import '../constants/fonts.dart';
import 'exchange_screen.dart';
import 'my_projects_screen.dart';
import 'price_home_screen.dart';

class MainHomeScreen extends StatelessWidget {
  const MainHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 5.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 5.h),

              // 👋 Welcome text
              Text(
                'Welcome!',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontFamily: figtreeFontBold,
                  color:textDarkColor,
                  letterSpacing: -0.5
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.5.h),

              // Subtitle
              Text(
                'Select a mode to continue',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: textGreyColor,
                    fontFamily: figtreeFontRegular,
                    // letterSpacing: -0.5
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 8.h),

              // 💰 Price Mode Card
              GestureDetector(
                // onTap: () => Get.to(() => const PriceHomeScreen()),
                onTap: () => Get.to(() =>  MyProjectsScreen()),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 3.w),
                  margin: EdgeInsets.only(bottom: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: borderLineColor, // light grey border
                      width: 1.5,                   // slightly thicker for visibility
                    ),
                  ),
                  child: Column(
                    children: [
                      // Icon in colored rounded box
                      Container(
                        height: 15.w,
                        width: 15.w,
                        decoration: BoxDecoration(
                          color: brandColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                            Icons.table_chart_rounded,
                            color: Colors.white,
                            size: 40
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Price Mode',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontFamily: figtreeFontSemiBold,
                          color: textDarkColor,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Input products and prices, generate breakdowns, export PDFs',
                        style: TextStyle(
                            fontSize: 15.sp,
                            color: textGreyColor,
                            fontFamily: figtreeFontRegular
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              // 💱 Exchange Mode Card
              GestureDetector(
                onTap: () => Get.to(() => const ExchangeScreen()),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 3.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: borderLineColor, // light grey border
                      width: 1.5,                   // slightly thicker for visibility
                    ),
                  ),

                  child: Column(
                    children: [
                      // Icon in colored rounded box
                      Container(
                        height: 15.w,
                        width: 15.w,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.currency_exchange,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Exchange Mode',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontFamily: figtreeFontSemiBold,
                          color: textDarkColor,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Set exchange rates and see product prices in both local and foreign currency',
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: textGreyColor,
                          fontFamily: figtreeFontRegular
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
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
