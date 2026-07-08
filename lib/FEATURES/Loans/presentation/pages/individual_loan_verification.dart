// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../data/models/loan_detail_model.dart';
// import '../../data/models/individual_loan_verification_model.dart';
// import '../../data/models/selected_location_model.dart';

// import '../../provider/individual_loan_verification.dart';

// import 'location_picker_page.dart';
// import 'individual_verify_success_page.dart';

// class IndividualLoanVerificationPage extends StatefulWidget {
//   final LoanDetailModel loan;

//   const IndividualLoanVerificationPage({super.key, required this.loan});

//   @override
//   State<IndividualLoanVerificationPage> createState() =>
//       _IndividualLoanVerificationPageState();
// }

// class _IndividualLoanVerificationPageState
//     extends State<IndividualLoanVerificationPage> {
//   final _formKey = GlobalKey<FormState>();

//   late TextEditingController feedbackController;
//   late TextEditingController addressController;
//   late TextEditingController landmarkController;
//   late TextEditingController stateController;
//   late TextEditingController districtController;
//   late TextEditingController pinCodeController;
//   late TextEditingController locationController;
//   String selectedGoogleMapLink = '';

//   double? selectedLatitude;
//   double? selectedLongitude;

//   @override
//   void initState() {
//     super.initState();

//     final customer = widget.loan.customer;

//     feedbackController = TextEditingController();

//     addressController = TextEditingController(text: customer.fullAddress);

//     landmarkController = TextEditingController(text: customer.landmark);

//     stateController = TextEditingController(text: customer.state);

//     districtController = TextEditingController(text: customer.district);

//     pinCodeController = TextEditingController(text: customer.pinCode);
//     locationController = TextEditingController();
//   }

//   @override
//   void dispose() {
//     feedbackController.dispose();
//     addressController.dispose();
//     landmarkController.dispose();
//     stateController.dispose();
//     districtController.dispose();
//     pinCodeController.dispose();
//     locationController.dispose();

//     super.dispose();
//   }

//   Future<void> chooseLocation() async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => const LocationPickerPage()),
//     );

//     if (result is SelectedLocationModel) {
//       setState(() {
//         selectedLatitude = result.latitude;
//         selectedLongitude = result.longitude;

//         locationController.text = '${result.address}\n${result.googleMapLink}';

//         selectedGoogleMapLink = result.googleMapLink;

//         stateController.text = result.state;

//         districtController.text = result.district;

//         pinCodeController.text = result.pinCode;
//       });
//     }
//   }

//   Widget buildField({
//     required String label,
//     required TextEditingController controller,
//     int maxLines = 1,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 14),
//       child: TextFormField(
//         controller: controller,
//         maxLines: maxLines,
//         validator: (value) {
//           if (value == null || value.trim().isEmpty) {
//             return '$label is required';
//           }
//           return null;
//         },
//         decoration: InputDecoration(
//           labelText: label,
//           filled: true,
//           fillColor: Colors.white,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       ),
//     );
//   }

//   Future<void> submitVerification() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     if (selectedLatitude == null || selectedLongitude == null) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('Please choose a location')));
//       return;
//     }

//     try {
//       final request = IndividualLoanVerificationModel(
//         feedback: feedbackController.text,
//         latitude: selectedLatitude.toString(),
//         longitude: selectedLongitude.toString(),
//         fullAddress: addressController.text,
//         landmark: landmarkController.text,
//         state: stateController.text,
//         district: districtController.text,
//         pinCode: pinCodeController.text,
//         googleMapLink: selectedGoogleMapLink,
//       );

//       final response = await context
//           .read<IndividualLoanVerificationProvider>()
//           .verifyLoan(loanId: widget.loan.loanId, data: request);

//       if (!mounted) return;

//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (_) => IndividualVerifySuccessPage(
//             loanId: response.loanId,
//             status: response.status,
//             verifiedBy: response.verifiedBy,
//             fullAddress: addressController.text,
//             googleMapLink: selectedGoogleMapLink,
//           ),
//         ),
//       );
//     } catch (e) {
//       if (!mounted) return;

//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text(e.toString())));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final loan = widget.loan;

//     return Scaffold(
//       backgroundColor: const Color(0xffF7F8FA),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: const Text('Verify Loan'),
//       ),
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       loan.loanId,
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     Text(
//                       '${loan.customer.name} (${loan.customer.customerId})',
//                       style: TextStyle(color: Colors.grey.shade600),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 20),

//               buildField(
//                 label: 'Feedback',
//                 controller: feedbackController,
//                 maxLines: 4,
//               ),

//               buildField(
//                 label: 'Full Address',
//                 controller: addressController,
//                 maxLines: 3,
//               ),
//               buildField(
//                 label: 'Location',
//                 controller: locationController,
//                 maxLines: 2,
//               ),

//               buildField(label: 'Landmark', controller: landmarkController),

//               buildField(label: 'State', controller: stateController),

//               buildField(label: 'District', controller: districtController),

//               buildField(label: 'Pin Code', controller: pinCodeController),

//               const SizedBox(height: 10),

//               SizedBox(
//                 width: double.infinity,
//                 height: 52,
//                 child: ElevatedButton.icon(
//                   onPressed: chooseLocation,
//                   icon: const Icon(Icons.map),
//                   label: const Text('Choose Location'),
//                 ),
//               ),

//               if (selectedLatitude != null && selectedLongitude != null)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 12),
//                   child: Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.green.shade50,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Text(
//                       'Location Selected',
//                       style: TextStyle(
//                         color: Colors.green.shade700,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),

//               const SizedBox(height: 32),

//               SizedBox(
//                 width: double.infinity,
//                 height: 52,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF2A9D8F),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   onPressed: submitVerification,
//                   child: const Text('Submit Verification'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/loan_detail_model.dart';
import '../../data/models/individual_loan_verification_model.dart';
import '../../data/models/selected_location_model.dart';

import '../../provider/individual_loan_verification.dart';

import 'location_picker_page.dart';
import 'individual_verify_success_page.dart';

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
  late TextEditingController pinCodeController;
  late TextEditingController locationController;
  String selectedGoogleMapLink = '';

  double? selectedLatitude;
  double? selectedLongitude;

  @override
  void initState() {
    super.initState();

    final customer = widget.loan.customer;

    feedbackController = TextEditingController();

    addressController = TextEditingController(text: customer.fullAddress);

    landmarkController = TextEditingController(text: customer.landmark);

    stateController = TextEditingController(text: customer.state);

    districtController = TextEditingController(text: customer.district);

    pinCodeController = TextEditingController(text: customer.pinCode);
    locationController = TextEditingController();
  }

  @override
  void dispose() {
    feedbackController.dispose();
    addressController.dispose();
    landmarkController.dispose();
    stateController.dispose();
    districtController.dispose();
    pinCodeController.dispose();
    locationController.dispose();

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

        pinCodeController.text = result.pinCode;
      });
    }
  }

  Widget buildField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '$label is required';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Future<void> submitVerification() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedLatitude == null || selectedLongitude == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please choose a location')));
      return;
    }

    try {
      final request = IndividualLoanVerificationModel(
        feedback: feedbackController.text,
        latitude: selectedLatitude.toString(),
        longitude: selectedLongitude.toString(),
        fullAddress: addressController.text,
        landmark: landmarkController.text,
        state: stateController.text,
        district: districtController.text,
        pinCode: pinCodeController.text,
        googleMapLink: selectedGoogleMapLink,
      );

      final response = await context
          .read<IndividualLoanVerificationProvider>()
          .verifyLoan(loanId: widget.loan.loanId, data: request);

      if (!mounted) return;

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
    }
  }

  @override
  Widget build(BuildContext context) {
    final loan = widget.loan;

    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Verify Loan'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loan.loanId,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${loan.customer.name} (${loan.customer.customerId})',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              buildField(
                label: 'Feedback',
                controller: feedbackController,
                maxLines: 4,
              ),

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

              // buildField(label: 'State', controller: stateController),

              // buildField(label: 'District', controller: districtController),

              buildField(label: 'Pin Code', controller: pinCodeController),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: chooseLocation,
                  icon: const Icon(Icons.map),
                  label: const Text('Choose Location'),
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
            ],
          ),
        ),
      ),

      // ── Fixed bottom button, stays put while form content scrolls ──
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: BoxDecoration(
            color: Colors.white,
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
                backgroundColor: const Color(0xFF2A9D8F),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: submitVerification,
              child: const Text(
                'Submit Verification',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}