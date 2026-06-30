// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../data/models/group_member_model.dart';
// import '../../data/models/group_verify_request_model.dart';
// import '../../data/models/selected_location_model.dart';

// import '../../provider/group_loan_verification_provider.dart';

// import 'location_picker_page.dart';
// import 'group_member_verify_success_page.dart';

// class GroupMemberVerificationPage extends StatefulWidget {
//   final String loanId;
//   final GroupMemberModel member;

//   const GroupMemberVerificationPage({
//     super.key,
//     required this.loanId,
//     required this.member,
//   });

//   @override
//   State<GroupMemberVerificationPage> createState() =>
//       _GroupMemberVerificationPageState();
// }

// class _GroupMemberVerificationPageState
//     extends State<GroupMemberVerificationPage> {
//   final _formKey = GlobalKey<FormState>();

//   final feedbackController = TextEditingController();
//   final addressController = TextEditingController();
//   final landmarkController = TextEditingController();
//   final stateController = TextEditingController();
//   final districtController = TextEditingController();
//   final pinCodeController = TextEditingController();
//   final locationController = TextEditingController();

//   String selectedGoogleMapLink = '';
//   double? selectedLatitude;
//   double? selectedLongitude;

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

//         locationController.text =
//             '${result.address}\n${result.googleMapLink}';

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
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please choose a location')),
//       );
//       return;
//     }

//     try {
//       final request = GroupVerifyRequestModel(
//         feedback: feedbackController.text,
//         members: [
//           GroupMemberVerifyRequestModel(
//             customerId: widget.member.customerId,
//             latitude: selectedLatitude.toString(),
//             longitude: selectedLongitude.toString(),
//             fullAddress: addressController.text,
//             landmark: landmarkController.text,
//             state: stateController.text,
//             district: districtController.text,
//             pinCode: pinCodeController.text,
//             googleMapLink: selectedGoogleMapLink,
//           ),
//         ],
//       );

//       final response = await context
//           .read<GroupLoanVerificationProvider>()
//           .verifyMember(loanId: widget.loanId, data: request);

//       if (!mounted) return;

//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (_) => GroupMemberVerifySuccessPage(
//             loanId: widget.loanId,
//             verifiedMemberName: widget.member.name,
//             response: response,
//           ),
//         ),
//       );
//     } catch (e) {
//       if (!mounted) return;

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(e.toString())),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffF7F8FA),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: const Text('Verify Member'),
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
//                 child: Row(
//                   children: [
//                     CircleAvatar(
//                       radius: 22,
//                       backgroundColor: const Color(0xFFFFF1E0),
//                       child: Text(
//                         widget.member.name.isNotEmpty
//                             ? widget.member.name[0].toUpperCase()
//                             : '?',
//                         style: const TextStyle(
//                           fontWeight: FontWeight.w700,
//                           color: Color(0xFFE08A2B),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             widget.member.name,
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             widget.member.customerCode,
//                             style: TextStyle(color: Colors.grey.shade600),
//                           ),
//                         ],
//                       ),
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

import '../../data/models/group_member_model.dart';
import '../../data/models/group_verify_request_model.dart';
import '../../data/models/selected_location_model.dart';

import '../../provider/group_loan_verification_provider.dart';

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
  final pinCodeController = TextEditingController();
  final googleMapLinkController = TextEditingController();

  double? selectedLatitude;
  double? selectedLongitude;

  @override
  void dispose() {
    feedbackController.dispose();
    addressController.dispose();
    landmarkController.dispose();
    stateController.dispose();
    districtController.dispose();
    pinCodeController.dispose();
    googleMapLinkController.dispose();
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
        pinCodeController.text = result.pinCode;
      });
    }
  }

  Widget _sectionField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    bool required = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: required
            ? (value) {
                if (value == null || value.trim().isEmpty) {
                  return '$label is required';
                }
                return null;
              }
            : null,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
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
            latitude: (selectedLatitude ?? 0).toString(),
            longitude: (selectedLongitude ?? 0).toString(),
            fullAddress: addressController.text,
            landmark: landmarkController.text,
            state: stateController.text,
            district: districtController.text,
            pinCode: pinCodeController.text,
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Verify Member'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Member header card ──────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
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
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.member.customerCode,
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: widget.member.isVerified
                                  ? const Color(0xFFE3F8EF)
                                  : const Color(0xFFFCEDE3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              widget.member.isVerified
                                  ? 'VERIFIED'
                                  : 'PENDING',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Customer Details',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _detailRow(Icons.phone, 'Phone', 'Not available'),
                    const SizedBox(height: 10),
                    _detailRow(Icons.location_on_outlined, 'Address',
                        'Not available'),
                    const SizedBox(height: 10),
                    _detailRow(Icons.groups_outlined, 'Group Loan ID',
                        widget.loanId),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Verification form ──────────────────────
              const Text(
                'Verification Form',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 12),

              _sectionField(
                label: 'Feedback',
                controller: feedbackController,
                maxLines: 4,
              ),
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
              _sectionField(label: 'Landmark', controller: landmarkController, required: false),
              _sectionField(label: 'State', controller: stateController),
              _sectionField(label: 'District', controller: districtController),
              _sectionField(label: 'Pin Code', controller: pinCodeController),

              const SizedBox(height: 6),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: chooseLocation,
                  icon: const Icon(Icons.map_outlined,
                      color: Color(0xFF38B2AC)),
                  label: const Text(
                    'Choose Location',
                    style: TextStyle(
                      color: Color(0xFF38B2AC),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF38B2AC)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF38B2AC),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  onPressed: submitVerification,
                  child: const Text(
                    'Submit Verification',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
          ),
        ),
      ],
    );
  }
}