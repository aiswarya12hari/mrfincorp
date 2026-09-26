import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../data/models/loan_detail_model.dart';
import '../../data/models/individual_loan_verification_model.dart';
import '../../data/models/selected_location_model.dart';

import '../../provider/individual_loan_verification.dart';
import '../../provider/loan_provider.dart';
import '../../../Dashboard/provider/dashboard_provider.dart';

import '../../../../CORE/Theme/app_color.dart';
import '../../../../CORE/Theme/app_text_style.dart';

import 'location_picker_page.dart';
import 'individual_verify_success_page.dart';
import '../widgets/verification_image_section.dart';

class IndividualLoanVerificationPage extends StatefulWidget {
  final LoanDetailModel loan;

  const IndividualLoanVerificationPage({super.key, required this.loan});

  @override
  State<IndividualLoanVerificationPage> createState() =>
      _IndividualLoanVerificationPageState();
}

class _IndividualLoanVerificationPageState
    extends State<IndividualLoanVerificationPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController feedbackController;
  late TextEditingController addressController;
  late TextEditingController landmarkController;
  late TextEditingController stateController;
  late TextEditingController districtController;
  // late TextEditingController pinCodeController;
  late TextEditingController locationController;
  late TextEditingController maxPayAmountController;
  String selectedGoogleMapLink = '';

  double? selectedLatitude;
  double? selectedLongitude;

  final List<XFile> _selectedImages = [];
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    final customer = widget.loan.customer;

    feedbackController = TextEditingController();
    addressController = TextEditingController(text: customer.fullAddress);
    landmarkController = TextEditingController(text: customer.landmark);
    stateController = TextEditingController(text: customer.state);
    districtController = TextEditingController(text: customer.district);
    // pinCodeController = TextEditingController(text: customer.pinCode);
    locationController = TextEditingController();
    maxPayAmountController = TextEditingController();
  }

  @override
  void dispose() {
    feedbackController.dispose();
    addressController.dispose();
    landmarkController.dispose();
    stateController.dispose();
    districtController.dispose();
    // pinCodeController.dispose();
    locationController.dispose();
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

        locationController.text = '${result.address}\n${result.googleMapLink}';

        selectedGoogleMapLink = result.googleMapLink;

        stateController.text = result.state;
        districtController.text = result.district;
        // pinCodeController.text = result.pinCode;
      });
    }
  }

  // ── Collection-style boxed field: label above, gray200 container ──
  Widget buildField({
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
    if (_isSubmitting) return;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedLatitude == null || selectedLongitude == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please choose a location')));
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final List<String> base64Images = [];
      for (final img in _selectedImages) {
        final bytes = await img.readAsBytes();
        if (!mounted) return;
        final base64Str = base64Encode(bytes);
        base64Images.add('data:image/jpeg;base64,$base64Str');
      }

      final request = IndividualLoanVerificationModel(
        feedback: feedbackController.text,
        maxPayAmount: maxPayAmountController.text,
        latitude: selectedLatitude.toString(),
        longitude: selectedLongitude.toString(),
        fullAddress: addressController.text,
        landmark: landmarkController.text,
        state: stateController.text,
        district: districtController.text,
        // pinCode: pinCodeController.text,
        googleMapLink: selectedGoogleMapLink,
        image: base64Images.isNotEmpty ? base64Images.first : null,
        images: base64Images.isNotEmpty ? base64Images : null,
      );

      final response = await context
          .read<IndividualLoanVerificationProvider>()
          .verifyLoan(loanId: widget.loan.loanId, data: request);

      if (!mounted) return;

      context.read<LoanProvider>().onLoanVerified(
        loanId: widget.loan.loanId,
        status: response.status,
      );
      context.read<DashboardProvider>().fetchDashboard(isRefresh: true);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => IndividualVerifySuccessPage(
            loanId: response.loanId,
            status: response.status,
            verifiedBy: response.verifiedBy,
            fullAddress: addressController.text,
            googleMapLink: selectedGoogleMapLink,
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
    final loan = widget.loan;

    return Scaffold(
      backgroundColor: AppColors.gray100,
      appBar: AppBar(
        backgroundColor: AppColors.gray100,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.gray800),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text('Verify Loan', style: AppTextStyles.pageTitle(context)),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header card: customer name + loan/customer ID ──
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
                      loan.customer.name,
                      style: AppTextStyles.cardCustomerName(
                        context,
                      ).copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${loan.loanId} • ${loan.customer.customerId}',
                      style: AppTextStyles.cardLoanId(context),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Verification fields ──
              buildField(
                label: 'Full Address',
                controller: addressController,
                maxLines: 3,
              ),
              buildField(
                label: 'Location',
                controller: locationController,
                maxLines: 2,
              ),
              buildField(label: 'Landmark', controller: landmarkController),
              // buildField(label: 'Pin Code', controller: pinCodeController),

              const SizedBox(height: 6),

              // ── Choose Location: now outlined (secondary action) ──
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: _isSubmitting ? null : chooseLocation,
                  icon: Icon(Icons.map_outlined, color: AppColors.primary),
                  label: Text(
                    'Choose Location',
                    style: AppTextStyles.button(
                      context,
                    ).copyWith(color: AppColors.primary),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.primary, width: 1.5),
                    backgroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              if (selectedLatitude != null && selectedLongitude != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Location Selected',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 18),

              // ── Optional Verification Photos below location details ──
              VerificationImageSection(
                images: _selectedImages,
                onImagesChanged: (imgs) => setState(() {
                  _selectedImages.clear();
                  _selectedImages.addAll(imgs);
                }),
                isSubmitting: _isSubmitting,
              ),

              // ── Max Pay Amount (hidden for Spot loans) ──
              if (loan.loanMethod != 'spot') ...[
                buildField(
                  label: 'Max Pay Amount',
                  controller: maxPayAmountController,
                  required: false,
                ),
              ],

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

      // ── Fixed bottom button ──
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
                disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
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
                  : Text(
                      'Submit Verification',
                      style: AppTextStyles.button(context),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
