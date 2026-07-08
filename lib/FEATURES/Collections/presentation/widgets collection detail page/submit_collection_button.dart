import 'package:flutter/material.dart';

import '../../../../CORE/Theme/app_color.dart';
import '../../../../CORE/Theme/app_text_style.dart';

class SubmitCollectionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const SubmitCollectionButton({
    super.key,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Submit Collection',
                    style: AppTextStyles.button(context),
                  ),
                ],
              ),
      ),
    );
  }
}
