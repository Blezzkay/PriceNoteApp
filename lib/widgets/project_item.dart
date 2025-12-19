import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';
import '../constants/fonts.dart';
import '../constants/imageAssets.dart';
import '../controllers/my_projects_controller.dart';
import '../models/project_model.dart';
import '../utils/get_random_colors.dart';

class ProjectItem extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ProjectItem({
    super.key,
    required this.project,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final ProjectController controller = Get.find();

    return GestureDetector(
      onTap: () => controller.openProject(project.id),
      child: Slidable(
        key: Key(project.id),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.55,
          children: [
            SlidableAction(
              onPressed: (_) => onEdit?.call(),
              backgroundColor: brandColor,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
              borderRadius: BorderRadius.circular(16),
            ),
            SlidableAction(
              onPressed: (_) => onDelete?.call(),
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: BorderRadius.circular(16),
            ),
          ],
        ),
        child: Container(
          margin: EdgeInsets.only(bottom: 2.h),
          padding: EdgeInsets.all(2.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            color: Colors.white,
          ),
          child: Row(
            children: [
              // 🔵 Brand Image or Colored Letter
              Container(
                height: 6.h,
                width: 6.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  image: project.brandImageUrl != null
                      ? DecorationImage(
                    image: NetworkImage(project.brandImageUrl!),
                    fit: BoxFit.cover,
                  )
                      : null,
                ),
                child: project.brandImageUrl == null
                    ? Center(
                  child: Text(
                    project.title.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      fontSize: 19.sp,
                      fontFamily: figtreeFontBold,
                      color: getRandomLetterColor(project.title),
                    ),
                  ),
                )
                    : null,
              ),

              SizedBox(width: 3.w),

              // 🔵 Text Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TITLE + PREMIUM TAG
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            project.title,
                            style: TextStyle(
                              fontSize: 17.sp,
                              fontFamily: figtreeFontSemiBold,
                              color: textDarkColor,
                            ),
                          ),
                        ),
                        if (project.isPremium)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2.w,
                              vertical: 0.4.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Image.asset(
                              Assets.premium_icon_png,
                              height: 2.5.h,
                              width: 2.5.h,
                              fit: BoxFit.contain,
                            ),
                          ),
                      ],
                    ),

                    SizedBox(height: 0.8.h),

                    // 📝 DESCRIPTION
                    Text(
                      project.description.isEmpty
                          ? "No description added"
                          : project.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: figtreeFontRegular,
                        color: textGreyColor,
                        fontSize: 14.sp,
                      ),
                    ),

                    SizedBox(height: 1.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
