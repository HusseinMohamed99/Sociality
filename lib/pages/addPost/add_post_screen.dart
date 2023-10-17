import 'package:socialite/model/user_model.dart';
import 'package:socialite/shared/components/image_with_shimmer.dart';
import 'package:socialite/shared/components/navigator.dart';
import 'package:socialite/shared/components/show_toast.dart';
import 'package:socialite/shared/cubit/socialCubit/social_cubit.dart';
import 'package:socialite/shared/cubit/socialCubit/social_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socialite/shared/utils/app_string.dart';
import 'package:socialite/shared/utils/color_manager.dart';

class AddPostScreen extends StatelessWidget {
  const AddPostScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController textController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    SocialCubit cubit = SocialCubit.get(context);
    UserModel userModel = SocialCubit.get(context).userModel!;
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if (state is CreatePostSuccessState) {
          cubit.getPosts();
          pop(context);
          showToast(
              text: AppString.createPostSuccessfully,
              state: ToastStates.success);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                pop(context);
                cubit.removePostImage();
              },
              icon: Icon(
                IconlyBroken.arrowLeft2,
                size: 24.sp,
                color: cubit.isDark
                    ? ColorManager.blackColor
                    : ColorManager.titanWithColor,
              ),
            ),
            titleSpacing: 1,
            title: Text(
              AppString.createPost,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  DateTime now = DateTime.now();
                  if (textController.text.trim().isNotEmpty &&
                      cubit.postImagePicked == null) {
                    cubit.createPost(
                      dateTime: now,
                      text: textController.text,
                    );
                    cubit.removePostImage();
                  } else if (cubit.postImagePicked != null) {
                    cubit.uploadPostImage(
                      dateTime: now,
                      text: textController.text,
                    );
                    pop(context);
                    cubit.removePostImage();
                  } else {
                    pop(context);
                  }
                },
                child: Text(
                  AppString.share,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ],
            elevation: 0,
          ),
          body: Column(
            children: [
              SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      if (state is CreatePostLoadingState)
                        const LinearProgressIndicator(),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 5,
                          left: 20,
                        ).r,
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 25.r,
                              child: ImageWithShimmer(
                                radius: 20.r,
                                imageUrl: userModel.image,
                                width: 50.w,
                                height: 50.h,
                                boxFit: BoxFit.fill,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userModel.name,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      IconlyLight.user2,
                                      color: cubit.isDark
                                          ? Colors.black
                                          : Colors.white,
                                      size: 14.sp,
                                    ),
                                    SizedBox(width: 5.w),
                                    Text(
                                      AppString.public,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            color: ColorManager.greyColor,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20).r,
                        child: TextFormField(
                          maxLines: 6,
                          minLines: 1,
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    color: cubit.isDark
                                        ? ColorManager.blackColor
                                        : ColorManager.titanWithColor,
                                  ),
                          controller: textController,
                          decoration: InputDecoration(
                            hintText: AppString.yourMind,
                            hintStyle: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: ColorManager.greyColor,
                                ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      if (SocialCubit.get(context).postImagePicked != null)
                        Stack(
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            Align(
                              alignment: AlignmentDirectional.bottomCenter,
                              child: Container(
                                height: 400.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10).r,
                                  boxShadow: [
                                    BoxShadow(
                                      color: ColorManager.greyColor
                                          .withOpacity(0.4),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10).r,
                                  child: Image(
                                    image: FileImage(cubit.postImagePicked!),
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                cubit.removePostImage();
                              },
                              icon: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: ColorManager.greyColor
                                          .withOpacity(0.4),
                                      blurRadius: 9,
                                      spreadRadius: 4,
                                      offset: const Offset(0, 4),
                                    )
                                  ],
                                ),
                                child: CircleAvatar(
                                  backgroundColor: ColorManager.redColor,
                                  child: Icon(
                                    Icons.close_rounded,
                                    color: Colors.white,
                                    size: 24.sp,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 30.h,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: cubit.isDark
                              ? ColorManager.titanWithColor
                              : ColorManager.primaryColor,
                        ),
                        onPressed: () {
                          cubit.getPostImage();
                        },
                        label: Text(
                          AppString.addPhoto.toUpperCase(),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        icon: Icon(
                          IconlyLight.image,
                          color: ColorManager.titanWithColor,
                          size: 24.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
