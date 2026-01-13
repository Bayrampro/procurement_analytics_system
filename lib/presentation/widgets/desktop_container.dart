import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class DesktopContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const DesktopContainer({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppConstants.maxContentWidth),
        child: Padding(
          padding: padding ??
              const EdgeInsets.symmetric(
                horizontal: AppConstants.desktopPadding,
                vertical: AppConstants.cardSpacing,
              ),
          child: child,
        ),
      ),
    );
  }
}
