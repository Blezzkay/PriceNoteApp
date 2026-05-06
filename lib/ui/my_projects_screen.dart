import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:price_note/constants/colors.dart';
import 'package:price_note/constants/fonts.dart';

import '../controllers/my_projects_controller.dart';
import '../widgets/project_item.dart';
import '../ui/show_create_project_sheet.dart';

class MyProjectsScreen extends StatelessWidget {
  MyProjectsScreen({super.key});

  final ProjectController controller = Get.put(ProjectController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      floatingActionButton: FloatingActionButton(
        onPressed: () => showCreateProjectSheet(context),
        backgroundColor: brandColor,
        elevation: 0,
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 19.sp,
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: 5.w,
            vertical: 2.h,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 🔙 Custom Header Row
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
                    'My Projects',
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontFamily: figtreeFontBold,
                      color: textDarkColor,
                    ),
                  ),
                  const SizedBox(width: 22),
                ],
              ),

              SizedBox(height: 3.h),

              // ⭐ PROJECT LIST
              Obx(() {
                if (controller.projects.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 15.h),
                      child: Text(
                        "No projects yet",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontFamily: figtreeFontRegular,
                          color: textGreyColor,
                        ),
                      ),
                    ),
                  );
                }

                return Column(
                  children: List.generate(
                    controller.projects.length,
                        (index) {
                      final project = controller.projects[index];

                      return Padding(
                        padding: EdgeInsets.only(bottom: 2.h),
                        child: ProjectItem(
                          project: project,

                          onEdit: () {
                            controller.editProject(index, project);
                          },

                          onDelete: () {
                            controller.deleteProject(index);
                          },
                        ),
                      );
                    },
                  ),
                );
              }),

              SizedBox(height: 3.h),
            ],
          ),
        ),
      ),
    );
  }
}
