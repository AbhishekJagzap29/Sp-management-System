import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sp_manage_system/Screen/Constant/app_assets.dart';
import 'package:sp_manage_system/Screen/Constant/app_color.dart';
import 'package:sp_manage_system/Screen/Constant/app_string.dart';
import 'package:sp_manage_system/Screen/Utils/extension.dart';


class NoInternetWidget extends StatelessWidget {
  final void Function()? onPressed;
  final double h;
  final double w;

  const NoInternetWidget(
      {super.key, this.onPressed, required this.h, required this.w});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: assetImage(AppAssets.noInternet, height: h * 0.32),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.18)
              .copyWith(top: h * 0.02),
          child: MaterialButton(
            onPressed: onPressed,
            color: appColor,
            height: h * 0.058,
            minWidth: w * 0.65,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppString.refresh.boldRobotoTextStyle(
                    fontSize: 16, fontColor: backGroundColor),
                (w * 0.02).addWSpace(),
                const Icon(Icons.refresh, color: Colors.white),
              ],
            ),
          ),
        ),
      ],
    ).paddingOnly(bottom: h * 0.012);
  }
}
