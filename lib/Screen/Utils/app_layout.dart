import 'package:flutter/material.dart';
import 'package:get/get.dart';

successSnackBar(
  String title,
  String message,
) {
  return Get.showSnackbar(
    GetSnackBar(
      titleText: Row(
        children: [
          Icon(
            Icons.done_all_outlined,
            color: Colors.blueGrey.shade700,
          ),
          const SizedBox(width: 5),
          Text(
            title.toString(),
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ],
      ),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      borderRadius: 8,
      backgroundColor: Colors.blueGrey.shade400,
      messageText: Text(
        message,
        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w400),
      ),
      borderWidth: 2.5,
      borderColor: Colors.blueGrey.shade700,
      duration: const Duration(seconds: 2),
      barBlur: 10,
    ),
  );
}

errorSnackBar(
  String title,
  String error,
) {
  return Get.showSnackbar(
    GetSnackBar(
      titleText: Row(
        children: [
          Icon(
            Icons.error,
            color: Colors.grey.shade400,
          ),
          const SizedBox(width: 5),
          Text(
            title.toString(),
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ],
      ),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      borderRadius: 8,
      backgroundColor: Colors.red.shade400,
      messageText: Text(
        error,
        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w400),
      ),
      borderWidth: 2.5,
      borderColor: Colors.red.shade800,
      duration: const Duration(seconds: 2),
      barBlur: 10,
    ),
  );
}

showCircular() {
  return const Center(
    child: /*Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        border: Border.all(color: appColor, width: 0.5),
        color: Colors.black,
        borderRadius: BorderRadius.circular(5),
      ),
      child: const Center(
        child: SpinKitSpinningLines(
          color: Colors.white,
          size: 25,
        ),
      ),
    )*/
        CircularProgressIndicator(color: Colors.black),
  );
}
