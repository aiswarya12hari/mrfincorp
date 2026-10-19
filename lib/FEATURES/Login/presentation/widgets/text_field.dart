import 'package:flutter/material.dart';
import 'package:mr_fincorp/CORE/Theme/app_color.dart';
import 'package:mr_fincorp/CORE/Theme/app_text_style.dart';

/// Reusable FinCorp text field matching the web UI styling.
/// [icon] is optional (defaults to null for clean web look).
/// Set [isPassword] to true to enable show/hide toggle.
class FincorpTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final IconData? icon;
  final bool isPassword;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const FincorpTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.icon,
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
  late final FocusNode _focusNode;
  bool _isFocused = false;

  static const Color _focusedBorder = Color(0xFF48D8C2); // Soft radiant aqua matching web button
  static const Color _cursorColor = Color(0xFF20C5A0);
  static const Color _focusedBlue = Color(0xFFEAF2FC);
  static const Color _unfocusedBg = Color(0xFFF1F5F9);

  @override
  void initState() {
    super.initState();
    _isObscured = widget.isPassword;
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (mounted) {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleObscure() => setState(() => _isObscured = !_isObscured);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          widget.label,
          style: AppTextStyles.label(context).copyWith(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1E293B),
          ),
        ),

        const SizedBox(height: 7),

        // Text Field
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          obscureText: _isObscured,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          cursorColor: _cursorColor,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: AppTextStyles.inputText(context).copyWith(
            fontSize: 14.5,
            color: const Color(0xFF1E293B),
            fontWeight: FontWeight.w500,
          ),
          textInputAction: widget.isPassword
              ? TextInputAction.done
              : TextInputAction.next,

          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: AppTextStyles.hint(context).copyWith(
              fontSize: 14,
              color: const Color(0xFFA0AEC0),
            ),
            errorStyle: const TextStyle(
              fontSize: 12,
              height: 1.3,
              color: AppColors.error,
              fontWeight: FontWeight.w500,
            ),

            // Prefix Icon only if provided
            prefixIcon: widget.icon != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Icon(
                      widget.icon,
                      size: 20,
                      color: _isFocused ? _focusedBorder : AppColors.textMuted,
                    ),
                  )
                : null,
            prefixIconConstraints: widget.icon != null
                ? const BoxConstraints(
                    minWidth: 48,
                    minHeight: 48,
                  )
                : null,

            // Password Toggle
            suffixIcon: widget.isPassword
                ? IconButton(
                    onPressed: _toggleObscure,
                    tooltip: _isObscured ? 'Show password' : 'Hide password',
                    icon: Icon(
                      _isObscured
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                      color: _isFocused ? _focusedBorder : const Color(0xFF94A3B8),
                    ),
                    splashRadius: 20,
                  )
                : null,

            suffixIconConstraints: const BoxConstraints(
              minWidth: 48,
              minHeight: 48,
            ),

            // Fill: Changes to blue on tap/focus (matching web UI)
            filled: true,
            fillColor: _isFocused ? _focusedBlue : _unfocusedBg,

            contentPadding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 16,
            ),

            // Web-style rounded borders with smooth focus transitions
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFE2E8F0),
                width: 1,
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: _focusedBorder,
                width: 1.3,
              ),
            ),

            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 1.2,
              ),
            ),

            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 1.6,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
