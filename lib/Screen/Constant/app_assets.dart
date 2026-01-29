import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sp_manage_system/Screen/Constant/app_color.dart';
import 'package:sp_manage_system/Screen/Utils/extension.dart';
import 'package:shimmer/shimmer.dart';

class AppAssets {
  static const imagePath = "assets/images/";

  static const appLogo = "${imagePath}logo.png";
  static const image1 = "${imagePath}image5.webp";
  static const image2 = "${imagePath}image4.png";
  static const image3 = "${imagePath}image2.png";
  static const arrowIcon = "${imagePath}arrow.png";
  static const searchIcon = "${imagePath}search.png";
  static const cameraIcon = "${imagePath}camera.png";
  static const closeIcon = "${imagePath}closeIcon.png";
  static const editIcon = "${imagePath}edit.png";
  static const noInternet = "${imagePath}no_internet.PNG";

  /// bottom bar

  static const bottom2 = "${imagePath}graph.svg";
  static const bottom3 = "${imagePath}clock.svg";
  static const bottom4 = "${imagePath}user.svg";

  /// project home screen

  static const engineer = "${imagePath}engineer.png";
  static const engineering = "${imagePath}engineering.png";
  static const shield = "${imagePath}shield.png";
  static const rawMaterials = "${imagePath}raw-materials.png";
}

Widget assetImage(String image,
    {double? height, double? width, Color? color, double? scale}) {
  return Image.asset(
    image,
    height: height,
    width: width,
    color: color,
    scale: scale,
  );
}

Widget networkImage(String image,
    {double? height, double? width, Color? color, double? scale}) {
  return Image.network(
    image,
    height: height,
    width: width,
    color: color,
  );
}

Widget networkImageShimmer(
    {required double h,
    required double w,
    required String url,
    double? radius,
    BoxFit? fit}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(radius ?? 10),
    child: CachedNetworkImage(
      height: h,
      width: w,
      imageUrl: url,
      fit: fit ?? BoxFit.cover,
      placeholder: (context, url) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.withOpacity(0.5),
          child: Container(
            height: h,
            width: w,
            color: Colors.grey,
          ),
        );
      },
      errorWidget: (context, url, error) {
        return Container(
          width: w,
          color: greyLightColor,
          child: Center(
            child: 'No Image!'.semiBoldBarlowTextStyle(),
          ),
        );
      },
    ),
  );
}
