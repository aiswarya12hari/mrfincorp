// import 'package:flutter/material.dart';

// import '../../data/models/group_verify_response_model.dart';

// class GroupAllVerifiedSuccessPage extends StatelessWidget {
//   final GroupVerifyResponseModel response;

//   const GroupAllVerifiedSuccessPage({super.key, required this.response});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffF7F8FA),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 const SizedBox(height: 40),

//                 Container(
//                   width: 100,
//                   height: 100,
//                   decoration: const BoxDecoration(
//                     color: Color(0xFFE8F8F6),
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(
//                     Icons.check_circle,
//                     size: 60,
//                     color: Color(0xFF2A9D8F),
//                   ),
//                 ),

//                 const SizedBox(height: 24),

//                 const Text(
//                   'All Members Verified Successfully!',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),

//                 const SizedBox(height: 12),

//                 const Text(
//                   'All members of this group loan have been verified successfully.',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: Colors.grey,
//                     height: 1.5,
//                   ),
//                 ),

//                 const SizedBox(height: 32),

//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Column(
//                     children: [
//                       _row(
//                         'Verified Members',
//                         '${response.verifiedCount} / ${response.totalMembers}',
//                       ),
//                       const Divider(),
//                       _row('Loan Status', response.status),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 16),

//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Column(
//                     children: [
//                       _row('Verified By', response.verifiedBy),
//                       const Divider(),
//                       _row('Loan ID', response.loanId),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 30),

//                 SizedBox(
//                   width: double.infinity,
//                   height: 52,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF2A9D8F),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     onPressed: () {
//                       Navigator.popUntil(
//                         context,
//                         (route) => route.isFirst,
//                       );
//                     },
//                     child: const Text('Back to Loans'),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _row(String title, String value) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(title, style: const TextStyle(color: Colors.grey)),
//         Flexible(
//           child: Text(
//             value,
//             textAlign: TextAlign.end,
//             style: const TextStyle(fontWeight: FontWeight.w600),
//           ),
//         ),
//       ],
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/models/group_verify_response_model.dart';

class GroupAllVerifiedSuccessPage extends StatelessWidget {
  final GroupVerifyResponseModel response;

  const GroupAllVerifiedSuccessPage({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    final verifiedOnText = DateFormat('d MMM yyyy, hh:mm a').format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50),

                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE3F8EF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    size: 56,
                    color: Color(0xFF1E9E6B),
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'All Members Verified\nSuccessfully!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'All members of this group loan have been verified successfully.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 32),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _row(
                        'Verified Members',
                        '${response.verifiedCount} / ${response.totalMembers}',
                      ),
                      const Divider(height: 1),
                      _statusRow('Loan Status', response.status),
                      const Divider(height: 1),
                      _row('Verified By', response.verifiedBy),
                      const Divider(height: 1),
                      _row('Verified On', verifiedOnText),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

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
                    onPressed: () {
                      Navigator.popUntil(
                        context,
                        (route) => route.isFirst,
                      );
                    },
                    child: const Text(
                      'Back to Group Loans',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F8EF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E9E6B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}