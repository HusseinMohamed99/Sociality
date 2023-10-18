import 'package:flutter/material.dart';
import 'package:socialite/shared/utils/color_manager.dart';

class AdaptiveIndicator extends StatelessWidget {
  const AdaptiveIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 120,
      child: CircularProgressIndicator.adaptive(
        value: 0.5,
        backgroundColor: ColorManager.greyColor,
        valueColor: AlwaysStoppedAnimation<Color>(ColorManager.mainColor),
        strokeWidth: 6,
      ),
    );
  }
}
