import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sociality/Pages/password/forget_password.dart';
import 'package:sociality/Pages/profile/user_profile_screen.dart';
import 'package:sociality/pages/password/change_password.dart';
import 'package:sociality/pages/profile/edit_profile_screen.dart';
import 'package:sociality/shared/components/image_with_shimmer.dart';
import 'package:sociality/shared/components/logout.dart';
import 'package:sociality/shared/components/navigator.dart';
import 'package:sociality/shared/cubit/socialCubit/social_cubit.dart';
import 'package:sociality/shared/cubit/socialCubit/social_state.dart';
import 'package:sociality/shared/components/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:sociality/shared/styles/color.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var userModel = SocialCubit.get(context).userModel!;
        SocialCubit cubit = SocialCubit.get(context);
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0).r,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Setting ',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10).r,
                  width: double.infinity,
                  height: 4.h,
                  color: AppMainColors.greyColor.withOpacity(0.2),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0).r,
                    child: InkWell(
                      onTap: () {
                        SocialCubit.get(context).getUserPosts(uId);
                        SocialCubit.get(context).getFriends(uId!);
                        navigateTo(context, const UserProfileScreen());
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 25.r,
                            child: ImageWithShimmer(
                              imageUrl: userModel.image,
                              width: 50.w,
                              height: 50.h,
                              radius: 15.r,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userModel.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                Text(
                                  'see your profile',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(color: AppMainColors.greyColor),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            IconlyLight.arrowRight2,
                            size: 24.sp,
                            color: AppMainColors.greyColor,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                space(0, 10),
                Text(
                  'Account',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10).r,
                  width: double.infinity,
                  height: 4.h,
                  color: AppMainColors.greyColor.withOpacity(0.2),
                ), //1
                SettingsListItem(
                  cubit: cubit,
                  iconData: IconlyBroken.profile,
                  text: 'Your Personal info',
                  function: () {
                    navigateTo(context, EditProfileScreen());
                  },
                ), //2
                SettingsListItem(
                  cubit: cubit,
                  iconData: IconlyBroken.lock,
                  text: 'Rest Password',
                  function: () {
                    navigateTo(context, RestPasswordScreen());
                  },
                ), //3
                SettingsListItem(
                  cubit: cubit,
                  iconData: IconlyBroken.unlock,
                  text: 'Change Password',
                  function: () {
                    bottomSheetChangePassword(
                      context: context,
                      cubit: cubit,
                    );
                  },
                ), //4
                SettingsListItem(
                  cubit: cubit,
                  iconData:
                      cubit.isDark ? Icons.nightlight_outlined : Icons.wb_sunny,
                  text: 'Theme Mode',
                  function: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.question,
                      animType: AnimType.topSlide,
                      title: 'Do you want to change mode ?',
                      btnOkOnPress: () {
                        cubit.changeAppMode();
                      },
                      btnCancelOnPress: () {
                        pop(context);
                      },
                    ).show();
                  },
                ),
                SettingsListItem(
                  cubit: cubit,
                  iconData: IconlyBroken.delete,
                  text: 'Delete your Account',
                  function: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.question,
                      animType: AnimType.topSlide,
                      title: "Do you want Delete Account ?",
                      btnOkOnPress: () {
                        cubit.deleteAccount(context);
                        Navigator.pop(context);
                      },
                      btnCancelOnPress: () {
                        pop(context);
                      },
                    ).show();
                  },
                ),
                SettingsListItem(
                  cubit: cubit,
                  iconData: Icons.power_settings_new_rounded,
                  text: 'LogOut',
                  function: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.question,
                      animType: AnimType.topSlide,
                      title: "Do you want LogOut ?",
                      btnOkOnPress: () {
                        logOut(context);
                        FirebaseAuth.instance.signOut();
                      },
                      btnCancelOnPress: () {
                        pop(context);
                      },
                    ).show();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SettingsListItem extends StatelessWidget {
  const SettingsListItem({
    super.key,
    required this.cubit,
    required this.text,
    required this.iconData,
    required this.function,
  });

  final SocialCubit cubit;
  final String text;
  final IconData iconData;
  final void Function()? function;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0).r,
        child: InkWell(
          onTap: () {
            function!();
          },
          child: Row(
            children: [
              Container(
                width: 60.w,
                height: 60.h,
                decoration: BoxDecoration(
                  color: AppMainColors.greyColor.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  iconData,
                  size: 50.sp,
                  color: AppMainColors.blackColor,
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                text,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Spacer(),
              Icon(
                IconlyLight.arrowRight2,
                size: 24.sp,
                color: AppMainColors.greyColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
