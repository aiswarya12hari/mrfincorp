import 'package:flutter/material.dart';

import '../../../../CORE/Theme/app_color.dart';
import '../../../../CORE/Theme/app_text_style.dart';

/// Redesigned premium fintech submit collection button.
/// Features:
/// - Full-width floating pill button (58px height)
/// - Teal gradient with soft drop shadow
/// - Animated press effect with smooth scaling
/// - Check icon on the left
/// - Maintains exact same business logic and callback contracts
class SubmitCollectionButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const SubmitCollectionButton({
    super.key,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  State<SubmitCollectionButton> createState() => _SubmitCollectionButtonState();
}

class _SubmitCollectionButtonState extends State<SubmitCollectionButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null && !widget.isLoading;

    return AnimatedScale(
      scale: _isPressed && isEnabled ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeInOut,
      child: Container(
        width: double.infinity,
        height: 58,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(29),
          gradient: isEnabled
              ? const LinearGradient(
                  colors: [
                    AppColors.secondary, // Web Aqua
                    AppColors.accent,    // Bright Aqua highlight
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isEnabled ? null : AppColors.gray400,
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: AppColors.secondary.withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(29),
            onHighlightChanged: (highlighted) {
              if (mounted) setState(() => _isPressed = highlighted);
            },
            onTap: widget.onPressed,
            splashColor: Colors.white.withValues(alpha: 0.15),
            highlightColor: Colors.white.withValues(alpha: 0.08),
            child: Center(
              child: widget.isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColors.white,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.white,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Submit Collection',
                          style: AppTextStyles.button(context).copyWith(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
