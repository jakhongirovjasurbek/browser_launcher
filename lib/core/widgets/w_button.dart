import 'package:browser_launcher/core/widgets/w_scale.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WButton extends StatelessWidget {
  final double? width;
  final double? height;
  final String text;
  final Color color;
  final Color textColor;
  final TextStyle? textStyle;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final GestureTapCallback onTap;
  final Widget? child;
  final BoxBorder? border;
  final bool loading;
  final bool disabled;
  final double? borderRadius;
  final Color disabledColor;

  const WButton({
    required this.onTap,
    this.width,
    this.borderRadius,
    this.height,
    this.text = '',
    this.color = const Color(0xff0062FF),
    this.textColor = Colors.white,
    this.textStyle,
    this.margin,
    this.padding,
    this.border,
    this.loading = false,
    this.disabled = false,
    this.disabledColor = Colors.grey,
    Key? key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => WScaleAnimation(
        onTap: () {
          if (!(loading || disabled)) {
            onTap();
          }
        },
        isDisabled: disabled,
        child: Container(
          width: width,
          height: height,
          margin: margin,
          padding: padding ?? const EdgeInsets.all(14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: disabled ? disabledColor : color,
            borderRadius: BorderRadius.circular(borderRadius ?? 8),
            border: border,
          ),
          child: loading
              ? const Center(
                  child: CupertinoActivityIndicator(),
                )
              : child ??
                  Text(
                    text,
                    style: textStyle ??
                        Theme.of(context).textTheme.headline3!.copyWith(
                              color: textColor,
                              fontSize: 16,
                            ),
                  ),
        ),
      );
}
