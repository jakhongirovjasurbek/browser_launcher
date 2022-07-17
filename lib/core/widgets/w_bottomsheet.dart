import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WBottomSheet extends StatelessWidget {
  final double borderRadius;
  final List<Widget> children;
  final List<Widget>? headerChildren;
  final Widget? bottomNavigation;
  final double? height;
  final EdgeInsets? contentPadding;
  final EdgeInsets? bottomNavigationPadding;
  final EdgeInsets? headerPadding;
  final bool hasHeader;
  final bool isScrollable;
  const WBottomSheet({
    required this.children,
    this.borderRadius = 12,
    this.isScrollable = false,
    this.hasHeader = true,
    this.height,
    this.bottomNavigation,
    this.contentPadding,
    this.headerChildren,
    this.bottomNavigationPadding,
    this.headerPadding,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 5,
            width: 36,
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(borderRadius),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (hasHeader)
                  Container(
                    padding: headerPadding ??
                        const EdgeInsets.only(left: 16, right: 16),
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              if (headerChildren != null) ...headerChildren!
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                Container(
                  padding: contentPadding ??
                      EdgeInsets.fromLTRB(
                        16,
                        16,
                        16,
                        MediaQuery.of(context).padding.bottom + 16,
                      ),
                  child: isScrollable
                      ? SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: children,
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: children,
                        ),
                ),
              ],
            ),
          ),
          if (bottomNavigation != null) ...{
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(width: 1, color: Color(0XFFF4F4F4)),
                ),
              ),
              child: Padding(
                padding: bottomNavigationPadding ??
                    EdgeInsets.only(
                      top: 20,
                      left: 16,
                      right: 16,
                      bottom: MediaQuery.of(context).padding.bottom + 20,
                    ),
                child: bottomNavigation,
              ),
            ),
          }
        ],
      );
}
