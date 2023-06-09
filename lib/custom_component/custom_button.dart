import 'package:flutter/material.dart';

//TODO: FIx this
// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  final String? label;
  final Widget? icon;
  final double? iconGap;
  final Function? onTap;
  bool? isLoading;
  final Color? color;
  final Color? textColor;
  final double? padding;
  final double? radius;
  final Widget? trailing;
  final double? textSize;
  final Color? borderColor;
  final double? height;
  CustomButton({
    this.label,
    this.icon,
    this.iconGap,
    this.onTap,
    this.isLoading,
    this.color,
    this.textColor,
    this.padding,
    this.radius,
    this.trailing,
    this.textSize,
    this.borderColor,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius ?? 8),
          border:
              Border.all(color: borderColor ?? Colors.transparent, width: 1.5),
          color: color ?? theme.primaryColor,
        ),
        padding: EdgeInsets.all(padding ?? (icon != null ? 16.0 : 18.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon ?? SizedBox.shrink(),
            icon != null ? SizedBox(width: iconGap ?? 20) : SizedBox.shrink(),
            isLoading != null
                ? (isLoading!
                    ? Container(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ))
                    : Text(
                        label ?? "",
                        textAlign: TextAlign.center,
                        style: theme.textTheme.button!.copyWith(
                            color: textColor ?? theme.scaffoldBackgroundColor,
                            fontSize: textSize ?? 16),
                      ))
                : Text(
                    label ?? "",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.button!.copyWith(
                        color: textColor ?? theme.scaffoldBackgroundColor,
                        fontSize: textSize ?? 16),
                  ),
            trailing != null ? Spacer() : SizedBox.shrink(),
            trailing ?? SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
