import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../resources/color_manager.dart';

void navigateTo(context, widget) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));

void popScreen(context) => Navigator.of(context).pop();

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => widget),
      (route) => false,
    );

getScreenWidth(BuildContext context) => MediaQuery.of(context).size.width;

getScreenHeight(BuildContext context) => MediaQuery.of(context).size.height;

myPrint({required String text}) {
  if (kDebugMode) {
    print(text);
  }
}

getDeco({
  required BuildContext context,
  bool withShadow = false,
  Color? color,
  double borderSize = 0.0,
  DecorationImage? image,
  Color? shadowColor,
}) {
  return BoxDecoration(
    color: color ?? Theme.of(context).primaryColor,
    borderRadius: BorderRadiusDirectional.only(
      bottomEnd: Radius.circular(borderSize),
      topEnd: Radius.circular(borderSize),
      bottomStart: Radius.circular(borderSize),
      topStart: Radius.circular(borderSize),
    ),
    boxShadow: withShadow
        ? [
            BoxShadow(
              color: shadowColor ?? Theme.of(context).primaryColorDark,
              blurRadius: 1.0,
              spreadRadius: 1.0,
              blurStyle: BlurStyle.outer,
            ),
            BoxShadow(
              color: shadowColor ?? Theme.of(context).primaryColorDark,
              blurRadius: 1.0,
              spreadRadius: 1.0,
              blurStyle: BlurStyle.outer,
            ),
            BoxShadow(
              color: shadowColor ?? Theme.of(context).primaryColorDark,
              blurRadius: 1.0,
              spreadRadius: 1.0,
              blurStyle: BlurStyle.outer,
            ),
          ]
        : [],
    image: image,
  );
}

String priceAfterDiscount({
  required num priceBefore,
  required num percent,
}) {
  return (priceBefore - (priceBefore * percent / 100)).toString();
}

Gradient getLinearGradient() {
  return LinearGradient(
    colors: [
      ColorManager.lightPrimary.withOpacity(.2),
      ColorManager.lightPrimary.withOpacity(.2),
      ColorManager.lightPrimary.withOpacity(.2),
      ColorManager.lightPrimary.withOpacity(.5),
      ColorManager.lightPrimary.withOpacity(.5),
      ColorManager.lightPrimary.withOpacity(.5),
      ColorManager.lightPrimary.withOpacity(.7),
      ColorManager.lightPrimary.withOpacity(.8),
      ColorManager.lightPrimary.withOpacity(.9),
      ColorManager.lightPrimary.withOpacity(.9),
      ColorManager.lightPrimary,
    ],
  );
}
