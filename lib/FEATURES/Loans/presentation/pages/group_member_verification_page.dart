import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/group_member_model.dart';
import '../../data/models/group_verify_request_model.dart';
import '../../data/models/selected_location_model.dart';

import '../../provider/group_loan_verification_provider.dart';

import '../../../../CORE/Theme/app_color.dart';
import '../../../../CORE/Theme/app_text_style.dart';

import 'location_picker_page.dart';
import 'group_member_verify_success_page.dart';

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

  // ── Collection-style boxed field: label above, gray200 container ──
  Widget _sectionField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    bool required = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: AppTextStyles.fieldLabel(
              context,
            ).copyWith(letterSpacing: 0.3),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.gray200,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextFormField(
              controller: controller,
              maxLines: maxLines,
              style: AppTextStyles.inputText(context),
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
                hintStyle: AppTextStyles.hint(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> submitVerification() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
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
          ),
        ],
      );

      final response = await context
          .read<GroupLoanVerificationProvider>()
          .verifyMember(loanId: widget.loanId, data: request);

      if (!mounted) return;

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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray100,
      appBar: AppBar(
        backgroundColor: AppColors.gray100,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.gray800),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text('Verify Member', style: AppTextStyles.pageTitle(context)),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Member header card ──────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gray800.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: widget.member.isVerified
                          ? const Color(0xFFE3F8EF)
                          : const Color(0xFFFCEDE3),
                      child: Text(
                        widget.member.name.isNotEmpty
                            ? widget.member.name[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: widget.member.isVerified
                              ? const Color(0xFF1E9E6B)
                              : const Color(0xFFE08A3C),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.member.name,
                            style: AppTextStyles.cardCustomerName(context),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.member.customerCode,
                            style: AppTextStyles.cardLoanId(context),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: widget.member.isVerified
                                  ? const Color(0xFFE3F8EF)
                                  : const Color(0xFFFCEDE3),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              widget.member.isVerified ? 'VERIFIED' : 'PENDING',
                              style: AppTextStyles.chipText(context).copyWith(
                                color: widget.member.isVerified
                                    ? const Color(0xFF1E9E6B)
                                    : const Color(0xFFE08A3C),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Customer details card ──────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gray800.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Customer Details',
                      style: AppTextStyles.cardCustomerName(
                        context,
                      ).copyWith(fontSize: 17),
                    ),
                    const SizedBox(height: 12),
                    _detailRow(Icons.phone, 'Phone', 'Not available'),
                    const SizedBox(height: 10),
                    _detailRow(
                      Icons.location_on_outlined,
                      'Address',
                      'Not available',
                    ),
                    const SizedBox(height: 10),
                    _detailRow(
                      Icons.groups_outlined,
                      'Group Loan ID',
                      widget.loanId,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Verification form ──────────────────────
              Text(
                'Verification Form',
                style: AppTextStyles.cardCustomerName(
                  context,
                ).copyWith(fontSize: 17),
              ),
              const SizedBox(height: 16),

              _sectionField(
                label: 'Full Address',
                controller: addressController,
                maxLines: 3,
              ),
              _sectionField(
                label: 'Location',
                controller: googleMapLinkController,
                required: false,
              ),
              _sectionField(
                label: 'Landmark',
                controller: landmarkController,
                required: false,
              ),
              // _sectionField(label: 'Pin Code', controller: pinCodeController),

              const SizedBox(height: 6),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: chooseLocation,
                  icon: Icon(Icons.map_outlined, color: AppColors.primary),
                  label: Text(
                    'Choose Location',
                    style: AppTextStyles.button(
                      context,
                    ).copyWith(color: AppColors.primary),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ── Max Pay Amount ──
              _sectionField(
                label: 'Max Pay Amount',
                controller: maxPayAmountController,
                required: false,
              ),

              // ── Feedback moved to bottom ──
              _sectionField(
                label: 'Feedback',
                controller: feedbackController,
                maxLines: 4,
              ),
            ],
          ),
        ),
      ),

      // ── Fixed bottom Submit Verification button ──
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.06),
                blurRadius: 12,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              onPressed: submitVerification,
              child: Text(
                'Submit Verification',
                style: AppTextStyles.button(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.gray600),
        const SizedBox(width: 10),
        Expanded(child: Text(label, style: AppTextStyles.fieldLabel(context))),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppTextStyles.fieldValue(context).copyWith(fontSize: 13),
          ),
        ),
      ],
    );
  }
}
