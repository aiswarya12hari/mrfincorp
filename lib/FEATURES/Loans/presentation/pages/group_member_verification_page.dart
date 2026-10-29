import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../data/models/group_member_model.dart';
import '../../data/models/group_verify_request_model.dart';
import '../../data/models/selected_location_model.dart';

import '../../provider/group_loan_verification_provider.dart';
import '../../provider/loan_provider.dart';
import '../../../Dashboard/provider/dashboard_provider.dart';

import '../../../../CORE/Theme/app_color.dart';
import '../../../../CORE/Theme/app_text_style.dart';

import 'location_picker_page.dart';
import 'group_member_verify_success_page.dart';
import '../widgets/verification_image_section.dart';

class GroupMemberVerificationPage extends StatefulWidget {
  final String loanId;
  final GroupMemberModel member;

  const GroupMemberVerificationPage({
    super.key,
    required this.loanId,
    required this.member,
  });

  @override
  State<GroupMemberVerificationPage> createState() =>
      _GroupMemberVerificationPageState();
}

class _GroupMemberVerificationPageState
    extends State<GroupMemberVerificationPage> {
  final _formKey = GlobalKey<FormState>();

  final feedbackController = TextEditingController();
  final addressController = TextEditingController();
  final landmarkController = TextEditingController();
  final stateController = TextEditingController();
  final districtController = TextEditingController();
  // final pinCodeController = TextEditingController();
  final googleMapLinkController = TextEditingController();
  final maxPayAmountController = TextEditingController();

  double? selectedLatitude;
  double? selectedLongitude;

  final Map<int, List<XFile>> _memberImages = {};
  bool _isSubmitting = false;

  @override
  void dispose() {
    feedbackController.dispose();
    addressController.dispose();
    landmarkController.dispose();
    stateController.dispose();
    districtController.dispose();
    // pinCodeController.dispose();
    googleMapLinkController.dispose();
    maxPayAmountController.dispose();
    super.dispose();
  }

  Future<void> chooseLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LocationPickerPage()),
    );

    if (result is SelectedLocationModel) {
      setState(() {
        selectedLatitude = result.latitude;
        selectedLongitude = result.longitude;

        addressController.text = result.address;
        googleMapLinkController.text = result.googleMapLink;
        stateController.text = result.state;
        districtController.text = result.district;
        // pinCodeController.text = result.pinCode;
      });
    }
  }

  // ── Collection-style boxed field: label above, modern rounded container ──
  Widget buildField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    bool required = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 7),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 14,
              vertical: maxLines > 1 ? 10 : 4,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: TextFormField(
              controller: controller,
              maxLines: maxLines,
              style: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 14,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              validator: required
                  ? (value) {
                      if (value == null || value.trim().isEmpty) {
                        return '$label is required';
                      }
                      return null;
                    }
                  : null,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: 'Enter $label',
                hintStyle: const TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 13.5,
                  color: AppColors.textMuted,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> submitVerification() async {
    if (_isSubmitting) return;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final List<String> base64Images = [];
      final memberImgs = _memberImages[widget.member.customerId] ?? [];
      for (final img in memberImgs) {
        final bytes = await img.readAsBytes();
        if (!mounted) return;
        final base64Str = base64Encode(bytes);
        base64Images.add('data:image/jpeg;base64,$base64Str');
      }

      final request = GroupVerifyRequestModel(
        feedback: feedbackController.text,
        members: [
          GroupMemberVerifyRequestModel(
            customerId: widget.member.customerId,
            maxPayAmount: maxPayAmountController.text,
            latitude: (selectedLatitude ?? 0).toString(),
            longitude: (selectedLongitude ?? 0).toString(),
            fullAddress: addressController.text,
            landmark: landmarkController.text,
            state: stateController.text,
            district: districtController.text,
            // pinCode: pinCodeController.text,
            googleMapLink: googleMapLinkController.text,
            image: base64Images.isNotEmpty ? base64Images.first : null,
            images: base64Images.isNotEmpty ? base64Images : null,
          ),
        ],
      );

      final response = await context
          .read<GroupLoanVerificationProvider>()
          .verifyMember(loanId: widget.loanId, data: request);

      if (!mounted) return;

      context.read<LoanProvider>().onLoanVerified(
        loanId: widget.loanId,
        status: response.status,
      );
      context.read<DashboardProvider>().fetchDashboard(isRefresh: true);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => GroupMemberVerifySuccessPage(
            loanId: widget.loanId,
            verifiedMemberName: widget.member.name,
            response: response,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Center(
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => Navigator.of(context).maybePop(),
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.surfaceSecondary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.textPrimary,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
        leadingWidth: 52,
        titleSpacing: 8,
        title: const Text(
          'Verify Member',
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Member header card ──────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        color: AppColors.secondaryDark,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.member.name,
                            style: const TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${widget.loanId} • ${widget.member.customerCode}',
                            style: const TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 12.5,
                              color: AppColors.textLight,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // ── Full Address ──
              buildField(
                label: 'Full Address',
                controller: addressController,
                maxLines: 3,
              ),

              // ── Location Field with Choose Location right near it ──
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Location',
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                            letterSpacing: 0.2,
                          ),
                        ),
                        InkWell(
                          onTap: _isSubmitting ? null : chooseLocation,
                          borderRadius: BorderRadius.circular(8),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.map_outlined,
                                  size: 15,
                                  color: AppColors.secondaryDark,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Choose Location',
                                  style: TextStyle(
                                    fontFamily: AppTextStyles.fontFamily,
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.secondaryDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border, width: 1),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: googleMapLinkController,
                              maxLines: 2,
                              style: const TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                fontSize: 14,
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Location is required';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                hintText: 'Enter Location',
                                hintStyle: TextStyle(
                                  fontFamily: AppTextStyles.fontFamily,
                                  fontSize: 13.5,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: _isSubmitting ? null : chooseLocation,
                            tooltip: 'Choose Location on Map',
                            icon: const Icon(
                              Icons.map_outlined,
                              color: AppColors.secondaryDark,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (selectedLatitude != null && selectedLongitude != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.successBg,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.success.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.check_circle_rounded,
                                color: AppColors.success,
                                size: 16,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Location Selected',
                                style: TextStyle(
                                  fontFamily: AppTextStyles.fontFamily,
                                  color: AppColors.success,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              buildField(
                label: 'Landmark',
                controller: landmarkController,
                required: false,
              ),

              const SizedBox(height: 18),

              // ── Optional Verification Photos below location details ──
              VerificationImageSection(
                images: _memberImages[widget.member.customerId] ?? [],
                onImagesChanged: (imgs) => setState(() {
                  _memberImages[widget.member.customerId] = imgs;
                }),
                isSubmitting: _isSubmitting,
              ),

              // ── Max Pay Amount ──
              buildField(
                label: 'Max Pay Amount',
                controller: maxPayAmountController,
                required: false,
              ),

              // ── Feedback moved to bottom ──
              buildField(
                label: 'Feedback',
                controller: feedbackController,
                maxLines: 4,
              ),
            ],
          ),
        ),
      ),

      // ── Fixed bottom verify button ──
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: Container(
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              gradient: _isSubmitting
                  ? null
                  : const LinearGradient(
                      colors: [AppColors.secondaryDark, AppColors.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              color: _isSubmitting
                  ? AppColors.secondaryDark.withValues(alpha: 0.7)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: AppColors.secondaryDark.withValues(alpha: 0.35),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.transparent,
                disabledForegroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
              ),
              onPressed: _isSubmitting ? null : submitVerification,
              child: _isSubmitting
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Submit Verification',
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
