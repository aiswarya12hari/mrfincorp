import 'package:flutter/material.dart';
import 'package:mr_fincorp/CORE/Theme/app_color.dart';
import 'package:mr_fincorp/CORE/Theme/app_text_style.dart';

/// Reusable FinCorp text field.
/// Pass [icon] from Flutter Icons.
/// Set [isPassword] to true to enable show/hide toggle.
class FincorpTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final IconData icon;
  final bool isPassword;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const FincorpTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.icon,
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  State<FincorpTextField> createState() => _FincorpTextFieldState();
}

class _FincorpTextFieldState extends State<FincorpTextField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.isPassword;
  }

  void _toggleObscure() => setState(() => _isObscured = !_isObscured);

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(widget.label, style: AppTextStyles.label(context)),

        SizedBox(
          height: mq.size.height * 0.014,
        ), // more breathing room, matches reference
        // Text Field
        TextFormField(
          controller: widget.controller,
          obscureText: _isObscured,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: AppTextStyles.inputText(context),
          textInputAction: widget.isPassword
              ? TextInputAction.done
              : TextInputAction.next,

          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: AppTextStyles.hint(context),

            errorStyle: const TextStyle(fontSize: 12, height: 1.2),

            // Prefix Icon
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Icon(widget.icon, size: 20, color: AppColors.primary),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 48,
              minHeight: 48,
            ),

            // Password Toggle
            suffixIcon: widget.isPassword
                ? GestureDetector(
                    onTap: _toggleObscure,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Icon(
                        _isObscured ? Icons.visibility_off : Icons.visibility,
                        size: 20,
                        color: AppColors.primary,
                      ),
                    ),
                  )
                : null,

            suffixIconConstraints: const BoxConstraints(
              minWidth: 48,
              minHeight: 48,
            ),

            // Fill
            filled: true,
            fillColor: AppColors.white,

            contentPadding: const EdgeInsets.symmetric(
              vertical: 18,
              horizontal: 16,
            ),

            // Borders
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: AppColors.borderColor,
                width: 1,
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),

            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.error, width: 1),
            ),

            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.error, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
